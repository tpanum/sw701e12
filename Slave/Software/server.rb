#!/usr/bin/env ruby

require 'rubygems'
require 'eventmachine'
require 'socket'
require 'json'
require 'ipaddr'

$drone = nil
CONTROL_PORT = 5556
NAV_PORT = 5554
DRONE_IP = "192.168.1.1"
MULTICAST_IP = "224.1.1.1"
TCP_LISTEN_PORT = 5123
TCP_SEND_PORT = 5124

u = UDPSocket.new
u.connect DRONE_IP, 1
@local_ip = u.addr.last
u.close

class SlaveServer
  HOST = "172.25.21.23"
  module EchoServer

    def post_init
      @flying ||= false
      @camera_channel ||= 0
    end

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
          when 'camera'
            @camera_channel = 1-@camera_channel
            puts 'CAMERA CHANNEL '+(@camera_channel+1).to_s
            $drone.camera @camera_channel+1
        end

        response_message = "{\"battery_level\":\"#{$drone.get_battery_level}\"}"
        send_data response_message

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

      @battery_level = 0

      config_ids @session_id, @user_id, @application_id
      video_codec
      navdata
    end

    def set_battery_level battery_level
      @battery_level = battery_level
    end

    def get_battery_level
      @battery_level
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
          puts 'Message sent : '+msg
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

    def camera channel
      set_option 'video:video_channel', channel.to_s
    end

    def video_codec
      set_option 'video:video_codec', '129'
    end

    def navdata
      set_option 'general:navdata_demo', 'TRUE'
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

    def ftrim
      push "AT*FTRIM=#{next_seq}<LF>"
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

    def set_option(name, value)
      push format_cmd *config(name, value)
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

    def configids(session_id, user_id, application_id)
      ['AT*CONFIG_IDS', "#{session_id},#{user_id},#{application_id}"]
    end

    def ref(input)
      ['AT*REF', input.to_i | REF_CONST]
    end

    def config(name, value)
      ['AT*CONFIG', "\"#{name}\",\"#{value}\""]
    end

  end

  module Session_server

    def post_init
      puts "Incomming connection"
    end

    def receive_data data
      if is_json?(data)
        obj = JSON.parse(data)
        session = obj['session']
        unless session.nil?
          @key = rand(36**40).to_s(36)
          @respond = "{\"sessionkey\":\"#{@key}\"}"
        else
          @respond = "{\"sessionkey\":\"invalid\"}"
        end
      else
        @respond = "{\"sessionkey\":\"invalid\"}"
      end
      send_data @respond
    end

    def unbind
      EventMachine::stop_event_loop
    end

    def is_json?(string)
      begin
        JSON.parse(string).all?
      rescue JSON::ParserError
        false
      end
    end

  end

  module NavDrone

    TAGS = {
      0      => :demo,
      16     => :vision_detected,
      18     => :iphone_angles,
      0xFFFF => :checksum,
    }

    STATE = {
      :flying              => 1 << 0,  # FLY MASK : (0) mykonos is landed, (1) mykonos is flying
      :video               => 1 << 1,  # VIDEO MASK : (0) video disable, (1) video enable
      :vision              => 1 << 2,  # VISION MASK : (0) vision disable, (1) vision enable
      :control             => 1 << 3,  # CONTROL ALGO : (0) euler angles control, (1) angular speed control
      :altitude            => 1 << 4,  # ALTITUDE CONTROL ALGO : (0) altitude control inactive (1) altitude control active
      :user_feedback_start => 1 << 5,  # USER feedback : Start button state
      :command             => 1 << 6,  # Control command ACK : (0) None, (1) one received
      :trim_command        => 1 << 7,  # Trim command ACK : (0) None, (1) one received
      :trim_running        => 1 << 8,  # Trim running : (0) none, (1) running
      :trim_result         => 1 << 9,  # Trim result : (0) failed, (1) succeeded
      :navdata_demo        => 1 << 10, # Navdata demo : (0) All navdata, (1) only navdata demo
      :navdata_bootstrap   => 1 << 11, # Navdata bootstrap : (0) options sent in all or demo mode, (1) no navdata options sent
      :motors_brushed      => 1 << 12, # Motors brushed : (0) brushless, (1) brushed
      :com_lost            => 1 << 13, # Communication Lost : (1) com problem, (0) Com is ok
      :gyros_zero          => 1 << 14, # Bit means that there's an hardware problem with gyrometers
      :vbat_low            => 1 << 15, # VBat low : (1) too low, (0) Ok
      :vbat_high           => 1 << 16, # VBat high (US mad) : (1) too high, (0) Ok
      :timer_elapsed       => 1 << 17, # Timer elapsed : (1) elapsed, (0) not elapsed
      :not_enough_power    => 1 << 18, # Power : (0) Ok, (1) not enough to fly
      :angles_out_of_range => 1 << 19, # Angles : (0) Ok, (1) out of range
      :wind                => 1 << 20, # Wind : (0) Ok, (1) too much to fly
      :ultrasound          => 1 << 21, # Ultrasonic sensor : (0) Ok, (1) deaf
      :cutout              => 1 << 22, # Cutout system detection : (0) Not detected, (1) detected
      :pic_version         => 1 << 23, # PIC Version number OK : (0) a bad version number, (1) version number is OK
      :atcodec_thread_on   => 1 << 24, # ATCodec thread ON : (0) thread OFF (1) thread ON
      :navdata_thread_on   => 1 << 25, # Navdata thread ON : (0) thread OFF (1) thread ON
      :video_thread_on     => 1 << 26, # Video thread ON : (0) thread OFF (1) thread ON
      :acq_thread_on       => 1 << 27, # Acquisition thread ON : (0) thread OFF (1) thread ON
      :ctrl_watchdog       => 1 << 28, # CTRL watchdog : (1) delay in control execution (> 5ms), (0) control is well scheduled
      :adc_watchdog        => 1 << 29, # ADC Watchdog : (1) delay in uart2 dsr (> 5ms), (0) uart2 is good
      :com_watchdog        => 1 << 30, # Communication Watchdog : (1) com problem, (0) Com is ok
      :emergency           => 1 << 31, # Emergency landing : (0) no emergency, (1) emergency
    }

    def setup(drone_ip, drone_nav_port)
      puts "setup #{drone_ip}:#{drone_nav_port}"
      @drone_ip = drone_ip
      @drone_nav_port = drone_nav_port
      @drone_nav_state = 0
    end

    def send_initial_message
      send_datagram 1, @drone_ip, @drone_nav_port
    end

    def receive_data(msg)
      puts "Received data"
      msg.freeze
      error = false
      prev_state = @drone_nav_state

      pointer = 0
      @header, @drone_nav_state, @seq_nav, @vision_flag = msg[pointer,16].unpack('VVVV')
      puts "Header: "+@header.to_s
      puts "State: "+@drone_nav_state.to_s
      puts "Seq: "+@seq_nav.to_s
      puts "Vision: "+@vision_flag.to_s
      pointer += 16

      puts msg.inspect

      # Compare states
      # compare_states prev_state, @drone_nav_state

      options = []

      option_id = msg[pointer, 2].unpack('v').first
      pointer += 2

      size = msg[pointer, 2].unpack('v').first
      pointer += 2

      battery = msg[pointer+4, 4].unpack('V').first
      puts "Battery voltage: "+battery.to_s

      $drone.set_battery_level battery

      # while pointer < msg.length
        # puts "Rest of message: "+msg[pointer, msg.length-pointer].inspect
        # puts msg[pointer,2].unpack('v')
        # puts "Pointer: "+pointer.to_s
        # option_id = msg[pointer, 2].unpack('v').first
        # pointer += 2
        # puts "Option: "+option_id.to_s

        # length = msg[pointer, 2].unpack('v').first
        # pointer += 2

        # puts "length:"+length.to_s

        # # Length is number of 16-bit ints
        # data = msg[pointer, length*2]
        # pointer += length*2
        # puts "Data: "+data.inspect

        # unless TAGS.keys.include?(option_id)
        #   puts "Found invalid options id: 0x%x" % option_id.inspect
        #   error = true
        #   next
        # end

        # unless length > 0
        #   puts "Found option #{TAGS[option_id]} with invalid length of 0"
        #   break
        # end
        # # puts "Decoded option #{TAGS[option_id]} with value #{data.inspect}"
        # options.push :id => option_id, :length => length, :data => data
      # end

      # Checksum is always the last option sent by the AR Drone
      # checksum = options.last
      # if checksum[:id] == TAGS.key(:checksum)
      #   validate checksum
      # else
      #   #puts "No checksum found for this packet.  Last option was tagged #{TAGS[checksum[:id]]}"
      # end
      puts "PACKET: #{msg.inspect}" if error
    end

    def compare_states old_state, new_state
      old_state ||= 0
      unless old_state == new_state
        diff = old_state ^ new_state
        changes = []
        STATE.each {|k,v| changes << "#{k} is now #{new_state & STATE[k] > 0 ? 1 : 0}" if diff & STATE[k] > 0}
      end
    end

    def in_bootstrap?
      @drone_nav_state & STATE[:navdata_bootstrap] > 0
    end

    def is_flying?
      @drone_nav_state & STATE[:flying] > 0
    end

    def communications_lost?
      @drone_nav_state & STATE[:com_lost] > 0
    end

    def altitude_limited?
      @drone_nav_state & STATE[:altitude] > 0
    end

    def is_battery_low?
      @drone_nav_state & STATE[:vbat_low] > 0
    end

    def validate_checksum msg, checksum
      # Calculated checksum
      calc = 0;
      # FIXME: Dunno why msg.byteslice(0, -8) returns nil
      # Only count bytes from the portion of the message excluding the checksum itself
      msg.byteslice(0, msg.bytesize - 8).each_byte { |c| calc += c }

      # Unpack the transmitted checksum
      checksum[:data] = checksum[:data].unpack('V').first

      # Simulate integer overflow
      calc %= (2**32-1)
      checksum[:data] == calc % (2**32-1)
    end

  end
end


EventMachine::run {
  drone = EventMachine.open_datagram_socket '0.0.0.0', CONTROL_PORT, SlaveServer::Drone
  drone.setup DRONE_IP, CONTROL_PORT

  $drone = drone

  listener = EventMachine::start_server '0.0.0.0', TCP_LISTEN_PORT, SlaveServer::EchoServer

  masterSender = EventMachine::connect(SlaveServer::HOST, TCP_SEND_PORT, SlaveServer::Handshake)
  masterSender.sendHello

  puts @local_ip
  droneNav = EventMachine.open_datagram_socket '0.0.0.0', NAV_PORT, SlaveServer::NavDrone
  droneNav.setup DRONE_IP, NAV_PORT
  ip = IPAddr.new(MULTICAST_IP).hton + IPAddr.new(@local_ip).hton
  droneNav.set_sock_opt(Socket::IPPROTO_IP, Socket::IP_ADD_MEMBERSHIP, ip)
  droneNav.send_initial_message

  EventMachine::start_server "0.0.0.0", 5122, SlaveServer::Session_server
}
