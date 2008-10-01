#!/usr/bin/env ruby -w
load "main.rb"

size = ARGV[0].to_i

a = 2

begin
	#puts a
	if a.bitsize == size
		#puts "=="*50
		if a.prime?
			puts "*"*10000000000000
		end
		a = a + 2
	elsif a.bitsize > size
		#puts "gt"
		a /= 2 + 1
	else
		#puts "lt"
		#a = a ** 2
		a = a * 5
	end

#end while !a.prime? && a.bitsize != size
#end while !a.prime?
end while a.bitsize != size

begin
	a += 2
end while !a.prime?

puts a 

puts a.prime?

puts a.bitsize
