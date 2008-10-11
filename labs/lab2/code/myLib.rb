#!/usr/bin/env ruby -w

class Integer

    def bytesize
    n = self
    i=0
    while n > 0
      n = n >> 8
      i += 1
    end
    return i
  end

  def bitsize
    n = self
    i=0
    while n > 0
      n = n >> 1
      i += 1
    end
    return i
  end

 def prime?
     n = self.abs()
     return true if n == 2
     return false if n == 1 || n & 1 == 0

     return false if n > 3 && n % 6 != 1 && n % 6 != 5 

     d = n-1
     d >>= 1 while d & 1 == 0
     20.times do                             
       a = rand(n-2) + 1
       t = d
       y = ModMath.pow(a,t,n)             
       while t != n-1 && y != 1 && y != n-1
         y = (y * y) % n
         t <<= 1
       end
       return false if y != n-1 && t & 1 == 0
     end
     return true
   end

end
 
module ModMath

   def ModMath.pow(base, power, mod)
     result = 1
     while power > 0
       result = (result * base) % mod if power & 1 == 1
       base = (base * base) % mod
       power >>= 1;
     end
     result
   end

end

class GCD

	def gcd(a, b)
		if b == 0
			#puts a
			return a
		else
			gcd(b, a % b)
		end
	end
end
