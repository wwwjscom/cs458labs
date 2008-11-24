#!/usr/bin/env ruby -w

require 'pcaplet'

network = Pcaplet.new('-n -i en1')
c = network.capture
dumper = Pcap::Dumper.open(c, "dump.txt")

puts "Dumping..."

network.each_packet do |pkt|
	dumper.dump(pkt)
end
