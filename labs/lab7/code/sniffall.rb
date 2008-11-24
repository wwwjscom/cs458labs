#!/usr/bin/env ruby -w

require 'pcaplet'

network = Pcaplet.new('-n -i en1')

network.each_packet do |pkt|
	begin
		puts "#{pkt.ip_src}:#{pkt.sport} #{pkt.ip_dst}:#{pkt.dport}"
	rescue
		nil
	end
end
