#! /usr/bin/env ruby -w

load "myLib.rb"

n = ARGV[0].to_i
e = ARGV[1].to_i
m = ARGV[2].to_i

cypher = Math.powmod(m, e, n)

puts cypher
