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
	e += 1
end

puts e

# To find d, iterate over all
# ints from 1 to totient. Test
# d * e = 1 * mod(totient), that
# is, ((d * e) -1) % totient == 0.

d = 1
while ((d * e) -1 ) % totient != 0
	d += 1
end

puts d

puts "Public key: (#{n}, #{e})"
puts "Private key: (#{n}, #{d})"

#end while gcd.gcd(e, totient) != 1
#puts gcd.gcd(e, totient)

#de = 1 (mod totient) = de = 1 + k * totient

#puts e
