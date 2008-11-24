#!/usr/bin/env ruby -w

require 'pcaplet'

network = Pcaplet.new('-r dump.txt -n')

network.each_packet do |pkt|
	begin
		puts "#{pkt.ip_src}:#{pkt.sport} #{pkt.ip_dst}:#{pkt.dport}"
	rescue
		nil
	end
end
