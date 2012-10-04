require 'socket'

host = '192.168.1.45'
port = 5123

s = TCPSocket.open(host, port)

@data = "{\"session\":\"true\", \"name\":\"dinmor\"}"
i = 0
while i < 1
	puts @data
	s.write(@data)
	i += 1
end
s.close