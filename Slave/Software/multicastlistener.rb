
require 'ipaddr'
require 'socket'
require 'multicast'

DRONE_IP = "192.168.1.1"
MULTICAST_ADDR = "224.1.1.1"
PORT = 5554

# ip = IPAddr.new(MULTICAST_ADDR).hton + IPAddr.new("0.0.0.0").hton
# sock = UDPSocket.new
# sock.bind("0.0.0.0", PORT)
# sock.setsockopt(Socket::IPPROTO_IP, Socket::IP_ADD_MEMBERSHIP, ip)

# puts "Sending wake-up call"
# sock.send('1', 0, DRONE_IP, PORT)

# puts "Sent wake-up call. Entering loop"
# loop do
#   puts "Entered loop"
#   msg, info = sock.recvfrom(1024)
#   puts "Received message"
#   puts "MSG: #{msg} from #{info[2]} (#{info[3]})/#{info[1]} len #{msg.size}"
# end
# puts "Exiting loop"

listener = Multicast::Listener.new(:group => MULTICAST_ADDR, :port => PORT)
listener.listen do |message|
    puts "---> [#{message.hostname} / #{message.ip}:#{message.port} (#{message.message.size} bytes)] #{message.message}"
end
