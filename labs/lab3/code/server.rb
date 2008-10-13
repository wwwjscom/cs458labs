#! /usr/bin/env ruby -w

require "socket"
load "client.rb"

def echo_server(n)
	ssock = TCPserver.open('127.0.0.1', 0)
	port = ssock.addr[1]
	if pid = fork then
		# parent is server
		csock = ssock.accept
		n = 0
		while str = csock.gets
			n += csock.write(str)
		end
		Process.wait
		printf "server processed %d bytes\n", n
	else
		# child is client
		echo_client(n, port)
	end
end

echo_server(Integer(ARGV.shift || 1))
