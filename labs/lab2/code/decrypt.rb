#! /usr/bin/env ruby -w

load "myLib.rb"

n = ARGV[0].to_i
d = ARGV[1].to_i
m = ARGV[2].to_i

#plaintext = (m ** d) % n
plaintext = Math.powmod(m, d, n)

puts plaintext
