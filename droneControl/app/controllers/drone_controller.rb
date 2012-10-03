class DroneController < ApplicationController
  require 'socket'
  require 'json'

  module Handler

    def post_init
      puts "Starting TLS"
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
    @request = "{\"session\":\"true\", \"name\":\"#{@drone.name}\"}"
    @request
  end

  def unbind
    EventMachine::stop_event_loop
  end

end

def new
end

def send_request
  EventMachine.run {
    EventMachine::connect "192.168.1.108", 5123, DroneController::Handler
  }

end

end
