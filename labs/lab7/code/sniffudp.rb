#!/usr/bin/env ruby -w

require 'pcaplet'

network = Pcaplet.new('-n -i en1')
udp_filter = Pcap::Filter.new('udp', network.capture)

network.each_packet do |pkt|
	puts "#{pkt.ip_src}:#{pkt.sport} #{pkt.ip_dst}:#{pkt.dport}" if udp_filter =~ pkt
end
