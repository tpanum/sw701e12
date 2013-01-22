require 'socket'
require 'eventmachine'
require 'json'
require 'open-uri'
require 'rexml/document'

# Sets the encvironment the daemons is ran in
ENV["RAILS_ENV"] ||= "development"

#Auto generated by the daemons-rails daemon generator
root = File.expand_path(File.dirname(__FILE__))
root = File.dirname(root) until File.exists?(File.join(root, 'config'))
require File.join(root, "config", "environment")

#Stops the daemon if rake daemon:____name__:stop is called, autogenerated. However since a loop is ran in the eventmachine this doesn't do anything.
$running = true
Signal.trap("TERM") do
  $running = false
end

#Module for handling incomming connections to the server
module Drone_connector

  #When a connection is established the following method is invoked
  def post_init
  end

  def receive_data data
    if is_json?(data)
      obj = JSON.parse(data)

      if !obj['slave_id'].nil?

        name = obj['slave_id']
        drone = Drone.where(:name => name).limit(1).first

        port, ip = Socket.unpack_sockaddr_in(get_peername)
        url = "http://api.hostip.info/?ip="+ip
        @xmldoc = open(url).read {|f|f.read}
        doc = REXML::Document.new(@xmldoc)

        doc.elements.each('//gml:name') do |c|
          @loc = c.text
        end

        unless drone.nil?
          if drone.ip != ip
            drone.ip = ip
            drone.location = @loc
            drone.save
          end
          drone.session.destroy unless drone.session.nil?
        else
          drone = Drone.new(:ip => ip, :name => name, :description => nil, :location => @loc)
          drone.save
        end
      elsif !obj['session_terminate_by_name'].nil?
        name = obj['session_terminate_by_name']
        drone = Drone.find_by_name(name).limit(1).first
        unless drone.nil?
          drone.session.destroy
        else
          puts "Received name of slave that has no drone"
        end
      else
        puts "I have no idea what to do with this JSON"
      end
    else
      puts "Received invalid non-JSON data"
    end

  end

  def unbind
  end

  def is_json?(string)
    begin
      JSON.parse(string).all?
    rescue JSON::ParserError
      false
    end
  end

end

# module Seskey_server

#   $request = false
#   #When a connection is established the following method is invoked
#   def post_init
#     puts "connected to seskey server"
#   end

#   def receive_data data
#     puts "received seskey_request"
#     @seskey1 = "invalidFromDaemon"
#     if $request == false
#       $request = true
#       if is_json?(data)
#         obj = JSON.parse(data)
#         if obj['request'] == "true"
#             EventMachine::run {
#               em = EventMachine::connect obj['ip'], 5122, Seskey_connector
#               @seskey1 = $seskey
#             }
#         end
#       end
#     end
#     $request = false
#     send_data "{\"sessionkey\":\"#{@seskey1}\"}"
#   end

#   def unbind

#   end

#   def is_json?(string)
#     begin
#       JSON.parse(string).all?
#     rescue JSON::ParserError
#       false
#     end
#   end

# end

module Seskey_connector
  def initialize *args
    super
    @drone = args[0]
  end

  def post_init
    send_data "{\"session\":\"true\"}"
  end

  def receive_data data
    if is_json?(data)
      obj = JSON.parse(data)
      unless obj['sessionkey'].nil?
        @seskey = obj['sessionkey']
        if @seskey != "invalid"
          session = @drone.session unless @drone.session.nil?
          session.session_key = @seskey unless session.nil?
          session.save unless session.nil?
        end
      end
      self.close_connection
    end
  end

  def unbind

  end

  def is_json?(string)
    begin
      JSON.parse(string).all?
    rescue JSON::ParserError
      false
    end
  end

end

def find_next_drone
  task = SessionKeyTask.first
  if !task.nil?
    task.destroy
    return task.drone
  else
    return nil
  end
end

while($running) do
  EventMachine::run {
    EventMachine::start_server "0.0.0.0", 5124, Drone_connector

    EventMachine::add_periodic_timer(1.0/10.0) do
      drone = find_next_drone
      EventMachine::connect drone.ip, 5125, Seskey_connector, drone unless drone.nil?
    end
  }

  sleep (1)
end
