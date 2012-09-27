#!/usr/bin/env ruby

require 'rubygems'
require 'eventmachine'
require 'json'

class SlaveServer
  HOST = "172.25.21.23"
  module EchoServer
    def receive_data data
      begin
        json = JSON.parse(data)
        puts echoCommand(json)
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
      slave_id = File.open('DO_NOT_REMOVE', 'r').gets
      send_data("{\"slave_id\":\"#{slave_id}\"}")
    end
  end
end


EventMachine::run {
  EventMachine::start_server '0.0.0.0', 5123, SlaveServer::EchoServer
  sender = EventMachine::connect(SlaveServer::HOST, 5124, SlaveServer::Handshake)
  sender.sendHello
}