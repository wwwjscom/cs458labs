#!/usr/bin/env ruby -w

require 'pcaplet'

network = Pcaplet.new('-n -i en1')

tcp_filter = Pcap::Filter.new('tcp', network.capture)

network.each_packet do |pkt|
	puts "#{pkt.ip_src}:#{pkt.sport} #{pkt.ip_dst}:#{pkt.dport}" if tcp_filter =~ pkt
end
