require 'eventmachine'

 module EchoServer
   def post_init
     puts "-- someone connected to the echo server!"
     send_data "You have connected to awesome server #101"
   end

   def receive_data data
   	 send_data data
   	 send_data "Data received"
     puts "#{data}"
     close_connection if data =~ /quit/i
   end

   def unbind
     puts "-- someone disconnected from the echo server!"
     send_data "You have disconnected to awesome server #101"
   end
 end

 EventMachine::run {
   EventMachine::start_server "0.0.0.0", 5123, EchoServer
 }