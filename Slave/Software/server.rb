#!/usr/bin/env ruby

require 'rubygems'
require 'eventmachine'
require 'json'

$drone = nil

class SlaveServer
  HOST = "172.25.21.23"
  module EchoServer
    
    @flying = false
    
    def receive_data data
      begin
        json = JSON.parse(data)
        
        puts echoCommand(json)
        
        case json['action']
          when 'flight'
            unless @flying
              $drone.takeoff
              puts 'TAKING OFF!'
              @flying = true
            else
              $drone.land
              puts 'LAND!'
              @flying = false
            end
          when 'forward'
            puts 'FORWARD'
            $drone.forward
          when 'backward'
            puts 'BACKWARD'
            $drone.backward
          when 'left'
            puts 'left'
            $drone.left
          when 'right'
            puts 'FORWARD'
            $drone.right
        end
      
      rescue JSON::ParserError
        puts "Too fast Bjarke, SLOWER!"
      end
    end
    
    def echoCommand(json)
      result = ""
      
      unless json['action'].nil?
        @t = json['action']
        result += "command: #{@t}"
      end
      
      result
      
    end
  end
  
  module Handshake  
    def sendHello
      slave_id = "XvBsDeRtA"
      send_data("{\"slave_id\":\"#{slave_id}\"}")
    end
  end
  
  module Drone
    
    REF_FLYING = 1 << 9
    REF_CONST = 290717696
    
    def setup(drone_ip, drone_control_port)
        @drone_ip = drone_ip
        @drone_control_port = drone_control_port

        @application_id = 'ARDrone'
        @user_id = 'bjarke'
        @session_id = "#{Socket.gethostname}:#{$$}"

        config_ids @session_id, @user_id, @application_id
    end
    
    def axis_reset
        @phi, @theta, @yaw, @gaz = 0, 0, 0, 0
    end

    def config_ids(session_id, user_id, application_id)
        push format_cmd *configids(session_id, user_id, application_id)
    end
    
    def format_cmd(cmd, data = nil)
        "#{cmd}=#{next_seq},#{data}\r"
    end

    def next_seq
        @seq = @seq.nil? ? 1 : @seq + 1
    end

    def push(msg)
        unless msg.empty?
          puts 'Message send : '+msg
          send_datagram(msg, @drone_ip, @drone_control_port)
        end
    end
    
    def float2int(float)
      [float.to_f].pack('e').unpack('l').first
    end
    
    def minmax(min, max, *args)
      args.map {|arg| arg < min ? min : arg > max ? max : arg }
    end

    def state_msg
        push format_cmd *ref(@drone_state)
    end
    
    def land
        @drone_state = 0
        state_msg
    end

    def takeoff
        ftrim
        @drone_state = REF_FLYING
        state_msg
    end

    def configids(session_id, user_id, application_id)
        ['AT*CONFIG_IDS', "#{session_id},#{user_id},#{application_id}"]
    end

    def ref(input)
        ['AT*REF', input.to_i | REF_CONST]
    end
    
    def ftrim
       push 'AT*FTRIM=1<LF>'
       next_seq
    end

    def forward
      flags = 1
      push format_cmd *pcmd(flags, 0, -0.4, 0, 0)
    end

    def backward
      flags = 1
      push format_cmd *pcmd(flags, 0, 0.4, 0, 0)
    end

    def left
      flags = 1
      push format_cmd *pcmd(flags, 0, 0, 0, -0.4)
    end

    def right
      flags = 1
      push format_cmd *pcmd(flags, 0, 0, 0, 0.4)
    end

    
    def pcmd(flags, phi, theta, gaz, yaw)
      values = [flags]

      # Ensure the inputs do not exceed [-1.0, 1.0]
      phi, theta, gaz, yaw = minmax -1.0, 1.0, phi, theta, gaz, yaw

      # Convert the values to IEEE 754, then cast to a signed int
      values += [phi, theta, gaz, yaw].map { |v|
        float2int v
      }
      ['AT*PCMD', values.join(',')]
    end
    
  end
end


EventMachine::run {
  drone = EventMachine.open_datagram_socket '0.0.0.0', 5556, SlaveServer::Drone
  drone.setup '192.168.1.1', 5556
  
  $drone = drone
  
  listener = EventMachine::start_server '0.0.0.0', 5123, SlaveServer::EchoServer

  masterSender = EventMachine::connect(SlaveServer::HOST, 5124, SlaveServer::Handshake)
  masterSender.sendHello
  
  
}