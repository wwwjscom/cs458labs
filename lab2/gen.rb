#!/usr/bin/env ruby -w
load "myLib.rb"

size = ARGV[0].to_i

a = 2

begin
	if a.bitsize == size
		a = a + 2
	elsif a.bitsize > size
		a /= 2 + 1
	else
		a = a * 5
	end

end while a.bitsize != size

begin
	a += 2
end while !a.prime?

puts a 
