#!/usr/bin/env ruby

# You might want to change this
include SessionKey
ENV["RAILS_ENV"] ||= "production"

root = File.expand_path(File.dirname(__FILE__))
root = File.dirname(root) until File.exists?(File.join(root, 'config'))
require File.join(root, "config", "environment")

@d = Drone.new


  $running = true
  Signal.trap("TERM") do 
    $running = false
  end

  while($running) do

  end