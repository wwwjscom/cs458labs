#!/usr/bin/env ruby -w

# Parses a dumped line from tcpdump
def parseDumpLine line
end

# Runs the tcpdump
# Probably needs to be threaded
# and have its output redirected
def dump
	@@thread = Thread.new do
		system("tcpdump -n -i en1")
	end
end

def setInterface i
end

def getInterface
end

# formats the output line
def output
end

def laters
	Thread.kill(@@thread)
end


def main
	@run = true
	setInterface "en1"

	dump

	command = gets.to_i

	while @run
		case command
			when 0 then 
				laters
				@run = false
		end
	end

end
# kick off program
main
