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

# Loop through the rules Array and print
def printRules
	
	@i = 1
	@@rulesArray.each do |rule|
		puts "#{@i}-#{rule.fetch('src_ip')}/#{rule.fetch('src_netmask')}:#{rule.fetch('src_port')} #{rule.fetch('dest_ip')}/#{rule.fetch('dest_netmask')}:#{rule.fetch('dest_port')} #{rule.fetch('protocol')} #{rule.fetch('action')}"
		@i += 1
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
end

def loadRules

	File.open("./rules").each do |line|
		
		ip = line.slice!(/.+-/)[0..-2]

		src_ip	= line.slice!(/\w*\//)[0..-2]

		src_netmask = line.slice!(/\w+:/)[0..-2]

		src_port = line.slice!(/\w+ /)[0..-2]

		dest_ip = line.slice!(/\w+\//)[0..-2]

		dest_netmask = line.slice!(/\w+:/)[0..-2]

		dest_port = line.slice!(/\w+ /)[0..-2]

		protocol = line.slice!(/\w+ /)[0..-2]

		action = line

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
end

def deleteRules
	toDelete = gets

	# Deletes all rules given seperated
	# by spaces
	toDelete.split(" ").each do |rule|
		# Delete the given rule
		@@rulesArray.delete_at((rule.to_i)-1)
	end
end

while true

	puts "1. Add Rule\n"
	puts "2. Delete Rule\n"
	puts "3. Print Rules\n"
	puts "4. Start Firewall\n"
	puts "5. Save Firewall\n"
	puts "6. Save Rules To File\n"
	puts "7. Load Rules From File\n"
	puts "8. Quit\n"

	# What should we do
	command = gets.to_i

	case command
		when 1 then addRule
		when 2 then deleteRules
		when 3 then printRules
		when 6 then writeFile
		when 7 then loadRules
	end
end
