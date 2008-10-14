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
		puts "[SERVER] Received: #{cyphertext}\n"

		#plaintext = e.decrypt(6085620532976717, 10142701089716483, cyphertext)
		plaintext = e.decrypt(10142701089716483, 6085620532976717, cyphertext)
		puts "[SERVER] Plaintext: #{plaintext}\n"

		cyphertext_new = e.encrypt(10142789312725007, 5, plaintext)
		puts "[SERVER] Cyphertext: #{cyphertext_new}\n"



			n += csock.write(str)
		end

		Process.wait

	else
		# child is client
		echo_client(n, port)
		return
	end
end
DATA = 34923459234099

def echo_client(n, port = 8081)
	sock = TCPsocket.open('127.0.0.1', port)

	puts "[CLIENT] Plaintext: #{DATA}\n"

	e = Encryption.new

	cyphertext = e.encrypt(10142701089716483, 5, DATA)
	puts "[CLIENT] Cyphertext: #{cyphertext}\n"


	cyphertext_s = cyphertext.to_s + "\n"
	n.times do
		sock.write(cyphertext_s)
		ans = sock.readline
	puts "[CLIENT] Cyphertext From Server: #{ans}\n"

	plaintext = e.decrypt(10142789312725007, 8114231289041741, ans.to_i)
	puts "[CLIENT] Plaintext From Server: #{plaintext}\n"



	end

	sock.close

end

#echo_server()
echo_server(Integer(ARGV.shift || 1))
#respond_server(Integer(ARGV.shift || 1))
