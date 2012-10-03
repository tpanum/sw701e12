  require 'socket'
  require 'json'
  require 'eventmachine'
  ENV["RAILS_ENV"] ||= "development"
  def send_request arg1
    if arg1.is_a? Integer
      @drone = Drone.find(arg1)
    else
      @drone = Drone.find_by_name(arg1)
    end
  @request = "{\"session\":\"true\", \"name\":\"#{@drone.name}\"}"
  s = TCPSocket.new(@drone.IP, 5123)
  s.send(send_request(1))

  end


