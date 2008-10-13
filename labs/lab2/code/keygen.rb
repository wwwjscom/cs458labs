#! /usr/bin/env ruby -w

load("myLib.rb")

p = ARGV[0].to_i
q = ARGV[1].to_i

n = p * q

totient = (p -1) * (q -1)

# Should be coprime to totient
gcd = GCD.new
e = 2

while gcd.gcd(e, totient) != 1
	puts "e"*20
	e += 1
end

#e = (2 ** 16) + 1

# To find d, iterate over all
# ints from 1 to totient. Test
# d * e = 1 * mod(totient), that
# is, ((d * e) -1) % totient == 0.

d = 1
#d = (totient + 1) / 2
#while ((d * e) -1 ) % totient != 0
while ((d * e) -1 ) % totient != 0
	puts d
	d += 1
	#d += 2
	#d -= 2
end

puts "Public key: (#{n}, #{e})"
puts "Private key: (#{n}, #{d})"
