#! /usr/bin/env ruby -w

require "socket"
load "myLib.rb"
#load "client.rb"

def echo_server(n)
	e = Encryption.new

	ssock = TCPserver.open('127.0.0.1', 8080)

	port = ssock.addr[1]
	if pid = fork then
		# parent is server
		csock = ssock.accept

		n = 0

		while str = csock.gets
			cyphertext = str.to_i
			puts "[SERVER]\t Message received from client...\n\n"
			puts "[SERVER]\t Received: \t\t\t#{cyphertext}\n"

			plaintext = e.decrypt(10142701089716483, 6085620532976717, cyphertext)
			puts "[SERVER]\t Plaintext: \t\t\t#{plaintext}\n"

			cyphertext = e.encrypt(10142789312725007, 5, plaintext)
			puts "[SERVER]\t Cyphertext: \t\t\t#{cyphertext}\n"
			puts "\n[SERVER]\t Sending back to client...\n\n"

			n += csock.write(cyphertext.to_s + "\n")
		end

		Process.wait

	else
		# child is client
		echo_client(n, port)
		return
	end
end

def echo_client(n, port = 8081)
	sock = TCPsocket.open('127.0.0.1', port)

	puts "\n\n[CLIENT]\t Plaintext: \t\t\t#{DATA}\n"

	e = Encryption.new

	cyphertext = e.encrypt(10142701089716483, 5, DATA)
	puts "[CLIENT]\t Cyphertext: \t\t\t#{cyphertext}\n"
	puts "\n[CLIENT]\t Sending to server...\n\n"


	cyphertext_s = cyphertext.to_s + "\n"
	n.times do
		sock.write(cyphertext_s)
		ans = sock.readline
		puts "[CLIENT]\t Cyphertext From Server: \t#{ans}"

		plaintext = e.decrypt(10142789312725007, 8114231289041741, ans.to_i)
		puts "[CLIENT]\t Plaintext From Server: \t#{plaintext}\n\n"



	end

	sock.close

end

DATA = ARGV[0]
echo_server(1)
