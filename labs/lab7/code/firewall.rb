#! /usr/bin/env ruby -w

require 'pcaplet'
require 'thread'

@@network = Pcaplet.new('-n -i en1')

tcp_filter = Pcap::Filter.new('tcp', @@network.capture)

@@os_ping = 0
@@os_pinger = 0
os_ping_time = 0

port_scanner = 0
@@d_port = 0
port_scan_count = 0

@run = true
@@rulesArray = Array.new

def addRule

	print "Enter Source IP(0.0.0.0 if all):"
	src_ip = gets.to_i

	print "Enter Source Netmask:"
	src_netmask = gets.to_i

	print "Enter Source Port(0 for all):"
	src_port = gets.to_i

	print "Enter Destination IP(0.0.0.0 if all):"
	dest_ip = gets.to_i

	print "Enter Destination Netmask:"
	dest_netmask = gets.to_i

	print "Enter Destination Port(0 for all):"
	dest_port = gets.to_i

	print "Enter Protocol(0-All, 1-ICMP, 6-TCP, 17-UDP):"
	protocol = gets.to_i

	print "Enter Action(0-Accept, 1-Drop):"
	action = gets.to_i

	# If everything is OK, add it to our array
	h = Hash.new{}
	h = 
		{
			"src_ip" => src_ip, 
			"src_netmask" => src_netmask,
			"src_port" => src_port,
			"dest_ip" => dest_ip,
			"dest_netmask" => dest_netmask,
			"dest_port" => dest_port,
			"protocol" => protocol,
			"action" => action
		}


	if validRule?(h) then
		@@rulesArray.push(h)
		puts "Rule added!"
	end
	#puts validRule?(h) ? "Rule added!" : "Error"
end

def validRule? rule

	src_ip 		= rule.fetch('src_ip')
	src_netmask 	= rule.fetch('src_netmask')
	src_port 	= rule.fetch('src_port')

	dest_ip 	= rule.fetch('dest_ip')
	dest_netmask 	= rule.fetch('dest_netmask')
	dest_port 	= rule.fetch('dest_port')

	protocol 	= rule.fetch('protocol')
	action 		= rule.fetch('action')

	@isOK = true
	@errMsg = ""

	if src_ip < 1
		@isOK = false
		@errMsg << "Source IP is invalid\n"
	end

	if src_netmask < 1
		@isOK = false
		@errMsg << "Source Mask is invalid\n"
	end

	if src_port < 1
		@isOK = false
		@errMsg << "Source Port is invalid\n"
	end

	if dest_ip < 1
		@isOK = false
		@errMsg << "Dest IP is invalid\n"
	end

	if dest_netmask < 1
		@isOK = false
		@errMsg << "Dest Mask is invalid\n"
	end

	if dest_port < 1
		@isOK = false
		@errMsg << "Dest Port is invalid\n"
	end

	#if protocol != 0 or protocol != 1 or protocol != 6 or protocol != 17
	#	@isOK = false
	#	@errMsg << "Protocol is invalid\n"
	#end

	if action < 0 or action > 1
		@isOK = false
		@errMsg << "Action is invalid\n"
	end
	# If there was an error
	if @isOK == false
		puts "Error! Unable to add rule!"
		puts @errMsg
		return false
	else
		return true
	end

end

def numeric?(object)
	true if Float(object) rescue false
end

# Loop through the rules Array and print
def printRules
	
	@i = 1
	@@rulesArray.each do |rule|
		puts "#{@i}-#{rule.fetch('src_ip')}/#{rule.fetch('src_netmask')}:#{rule.fetch('src_port')} #{rule.fetch('dest_ip')}/#{rule.fetch('dest_netmask')}:#{rule.fetch('dest_port')} #{rule.fetch('protocol')} #{rule.fetch('action')}"
		@i += 1
	end

	if @i == 1
		puts "No rules to print!"
	else
		puts "Rules Loaded!"
	end
end

# Write the rules array to file, correctly formatted.
def writeFile

	outputFile = File.new("./rules", "w")

	@i = 1
	@@rulesArray.each do |rule|
		outputFile.puts "#{@i}-#{rule.fetch('src_ip')}/#{rule.fetch('src_netmask')}:#{rule.fetch('src_port')} #{rule.fetch('dest_ip')}/#{rule.fetch('dest_netmask')}:#{rule.fetch('dest_port')} #{rule.fetch('protocol')} #{rule.fetch('action')}"
		@i += 1
	end

	outputFile.close

	puts "Rules Saved!"
end

def writeLog ip, reason

	outputFile = File.new("./ids.txt", "a")

	t = Time.new

	outputFile.puts "#{t.strftime("%Y%m%d-%H:%M.%S")} #{ip} #{reason}"

	outputFile.close
end

def loadRules

	@i = 1

	File.open("./rules").each do |line|
		
		line = line.chop

		ip = line.slice!(/.+-/)[0..-2].to_i

		src_ip	= line.slice!(/\w*\//)[0..-2].to_i

		src_netmask = line.slice!(/\w+:/)[0..-2].to_i

		src_port = line.slice!(/\w+ /)[0..-2].to_i

		dest_ip = line.slice!(/\w+\//)[0..-2].to_i

		dest_netmask = line.slice!(/\w+:/)[0..-2].to_i

		dest_port = line.slice!(/\w+ /)[0..-2].to_i

		protocol = line.slice!(/\w+ /)[0..-2].to_i

		action = line.to_i

		h = Hash.new{}
		h =
			{
				"src_ip" => src_ip, 
				"src_netmask" => src_netmask,
				"src_port" => src_port,
				"dest_ip" => dest_ip,
				"dest_netmask" => dest_netmask,
				"dest_port" => dest_port,
				"protocol" => protocol,
				"action" => action
			}

		if validRule?(h) 
			@@rulesArray.push(h)
		else
			puts "Error parsing line #{@i}"
		end

		@i += 1
	end

	puts "Rules Loaded!"
end

def deleteRules
	toDelete = gets

	# Deletes all rules given seperated
	# by spaces
	toDelete.split(" ").each do |rule|
		# Delete the given rule
		@@rulesArray.delete_at((rule.to_i)-1)
	end

	puts "Rule deleted!"
end

def startFirewall
	cmd = "ipfw -q add"

	# flush
	system('ipfw -q -f flush')

	@i = 0
	@@rulesArray.each do |rule|

		sip = rule.fetch('src_ip')
		dip = rule.fetch('dest_ip')
		sport = rule.fetch('src_port')
		action = rule.fetch('action')
		protocol = rule.fetch('protocol')

		# Build the rule itself
		feed = "#{action} #{protocol} from #{dip} to #{sip} #{sport}"

		# Build the complete rule
		exec = "#{cmd} #{feed}"

		# Add the rule
		system(exec)

		@i += 1
	end

	# start the firewall
	system('sh /usr/local/etc/ipfw.rules')

	puts "Firewall Started!"
end

def stopFirewall
	#system('ipfw -q -f flush')
	puts "Firewall Stopped!"
end


def monitor
	@@network.each_packet do |pkt|

		begin
			###			###
			### Detect NOP Payloads ###
			###			###

			if pkt.tcp_data.to_s =~ /NOP/
				writeLog(pkt.ip_src, "Buffer Overflow")
				# Flag for NOP payload
			end


			###			    ###
			### Check for port scanning ###
			###			    ###
			
			if (pkt.dport == (@@d_port + 1)) and (pkt.ip_src == port_scanner) then
				# They have searched for the next sequential port
				@@d_port += 1
				port_scan_count += 1

				if port_scan_count >= 5 then
					# Block them
					writeLog(pkt.ip_src, "Port Scan")

					# reset variables
					port_scanner = 0
					@@d_port = 0
					port_scan_count = 0
				end
			else
				# Brand new scan
				port_scanner = pkt.ip_src
				@@d_port = pkt.dport
				port_scan_count = 1
			end

			puts "Port Scanner: #{port_scanner}"
			puts "Dest Port: #{@@d_port}"
			puts "Port Scan Count: #{port_scan_count}"


			###			 ###
			### Check for OS Pinging ###
			###			 ###
			
			if (pkt.tcp_fin? or pkt.tcp_ack? or pkt.tcp_syn?) and (pkt.ip_src == @@os_pinger) then
				@@os_pinger = pkt.ip_src
				@@os_ping += 1
			else
				os_ping_time = Time.new
				@@os_ping = 0
				@@os_pinger = pkt.ip_src
			end

			if @@os_ping >= 5 and (Time.new - os_ping_time) < 20  then
				writeLog(pkt.ip_src, "OS Fingerprinting")
				
				@@os_ping = 0
				@@os_pinger = 0
				# block IP for OS pinging
			end

			# Debug outputs
			puts "OS Ping Time: #{os_ping_time}"
			puts "OS Ping: #{@@os_ping}"
			puts "OS Pinger: #{@@os_pinger}"


		rescue
			nil
		end
	end
end

def verbose
	@@network.each_packet do |pkt|
		puts "#{pkt.ip_src}:#{pkt.sport} #{pkt.ip_dst}:#{pkt.dport}"
	end
end

def countdown
	stop_time = Time.new.to_f + 10

	thread = Thread.new{ while true do verbose end }

	while true do
		if Time.new.to_f < stop_time then
			nil
		else
			Thread.kill(thread)
			break
		end
	end

end

def read_IDS

	@i = 1

	File.open("./ids.txt").each do |line|
		
		line = line.chop

		line = line[( line.index(' ') + 1 )..-1]

		puts "#{@i}-#{line}"

	
		@i = @i + 1
	end
end

while @run

	puts "1. Start IDS"
	puts "2. Stop IDS"
	puts "3. View Current Traffic"
	puts "4. View Block List"
	puts "5. View Current Firewall Rules"
	puts "6. Unlock User"
	puts "7. Quit"

	#puts "1. Add Rule\n"
	#puts "2. Delete Rule\n"
	#puts "3. Print Rules\n"
	#puts "4. Start Firewall\n"
	#puts "5. Stop Firewall\n"
	#puts "6. Save Rules To File\n"
	#puts "7. Load Rules From File\n"
	#puts "8. Quit\n"

	# What should we do
	command = gets.to_i

	case command
		#when 1 then addRule
		#when 2 then deleteRules
		#when 3 then printRules
		#when 4 then startFirewall
		#when 5 then stopFirewall
		#when 6 then writeFile
		#when 7 then loadRules
		when 1 then @@t = Thread.new{ monitor }
		when 2 then Thread.kill(@@t)
		when 3 then countdown
		when 4 then read_IDS
		when 7 then
			puts "Bye now!" 
			@run = false 
	end
end
