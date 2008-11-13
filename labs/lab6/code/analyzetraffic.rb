#!/usr/bin/env ruby -w

require 'pcaplet'

qterm = ARGV[0]

network = Pcaplet.new('-n -i en1 -s 1500')

network.each_packet do |pkt|
	begin
		if pkt.tcp_data =~ input
			puts "Matched: #{pkt.ip_src}:#{pkt.sport} #{pkt.ip_dst}:#{pkt.dport}"
		end
	rescue
		nil
	end
end
