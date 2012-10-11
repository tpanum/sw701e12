class DroneController < ApplicationController
  require 'socket'
  require 'json'

  module Handler

    def post_init
      puts "before send"
      data = request(1)
      send_data data
      puts "after send"
    end

    def receive_data data
      port, ip = Socket.unpack_sockaddr_in(get_peername)
      puts "got #{data.inspect} from #{ip}:#{port}"
    end

    def request arg1
     if arg1.is_a? Integer
      @drone = Drone.find(arg1)
    else
      @drone = Drone.find_by_name(arg1)
    end
    @request = "{\"session\":\"true\"}"
    @request
  end

  def unbind
    EventMachine::stop_event_loop
  end

end

module Session_server

  def post_init
    puts "Incomming connection"
  end

  def receive_data data
    puts data
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
    puts @respond
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

def new

end

def send_session
  EventMachine.run {
    EventMachine::start_server "0.0.0.0", 5123, DroneController::Session_server
  }
end

def send_request 
  EventMachine.run {
    EventMachine::connect "192.168.1.108", 5123, DroneController::Handler
  }
end

end
