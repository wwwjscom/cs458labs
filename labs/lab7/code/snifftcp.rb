#!/usr/bin/env ruby -w

require 'pcaplet'

network = Pcaplet.new('-n -i en1')

tcp_filter = Pcap::Filter.new('tcp', network.capture)

os_ping = 0
os_pinger = 0
os_ping_time = 0

network.each_packet do |pkt|
	#puts "#{pkt.ip_src}:#{pkt.sport} #{pkt.ip_dst}:#{pkt.dport}" if tcp_filter =~ pkt


	begin

		if (pkt.tcp_fin? or pkt.tcp_ack? or pkt.tcp_syn?) and (pkt.ip_src == os_pinger) then
			os_pinger = pkt.ip_src
			os_ping += 1
		else
			os_ping_time = Time.new
			os_ping = 0
			os_pinger = pkt.ip_src
		end

		if os_ping >= 5 and (Time.new - os_ping_time) < 20  then
			# block IP for OS pinging
		end

		puts "OS Ping Time: #{os_ping_time}"
		puts "OS Ping: #{os_ping}"
		puts "OS Pinger: #{os_pinger}"

	rescue
		nil
	end
end
