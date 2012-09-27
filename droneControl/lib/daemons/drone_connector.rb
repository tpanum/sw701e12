require 'socket'
require 'eventmachine'
require 'json'

# You might want to change this
ENV["RAILS_ENV"] ||= "development"

root = File.expand_path(File.dirname(__FILE__))
root = File.dirname(root) until File.exists?(File.join(root, 'config'))
require File.join(root, "config", "environment")

$running = true
Signal.trap("TERM") do 
  $running = false
end

module Handler
  def post_init
    puts "-- someone connected to the echo server!"
    send_data "I see you the Rasmus"
  end

  def receive_data data 
    port, ip = Socket.unpack_sockaddr_in(get_peername)
    puts "got #{data.inspect} from #{ip}:#{port}"
    send_data "I see IPs and sockets"
    c = Connections.new(:port => port, :id => ip)
    c.save
    if is_json?(data)
      obj = JSON.parse(data)
      sid = obj['slave_id']
      puts sid 
    end
    
  end

  def unbind
    puts "-- someone disconnected from the echo server!"
  end

  def is_json?(string)
    begin
      JSON.parse(string).all?
    rescue JSON::ParserError
      false
    end
  end

end

while($running) do  
  EventMachine::run {
    puts "test"
    EventMachine::start_server "0.0.0.0", 5124, Handler
  }
  puts "done"
  sleep (1)
end
