#! /usr/bin/env ruby -w

@@rulesArray = Array.new{}

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

	@@rulesArray.push(h)
end

def printRules
	
end

while true

	puts "1. Add Rule\n"
	puts "2. Delete Rule\n"
	puts "3. Print Rules\n"
	puts "4. Start Firewall\n"
	puts "5. Save Firewall\n"
	puts "6. Save Ruesl To File\n"
	puts "7. Load Rules From File\n"
	puts "8. Quit\n"

	# What should we do
	command = gets.to_i

	case command
		when 1 then addRule
		when 2 then puts @@rulesArray.to_s
	end
end
