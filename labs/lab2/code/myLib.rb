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

# Calculate ((b**p) % m) assuming that b and m are large integers.
def Math.powmod(b, p, m)
	if p == 1
		b % m
	elsif (p & 0x1) == 0 # p.even?
		t = powmod(b, p >> 1, m)
		(t * t) % m
	else
		(b * powmod(b, p-1, m)) % m
	end
end

class Jacobian

	def findRepeat(p)
		j = Jacobian.new

		for i in (1..25)
			if(j.find(p) == false)
				return false
			end
		end

		return true
	end


	def find(p)
		r = rand(p-1)
		r = r + 1

		j = Jacobian.new
		return j.jacobian(r, p)
	end

	def jacobian(r, p)

		gcd = GCD.new
		j = Jacobian.new

		# Test 1
		if(gcd.gcd(r, p) == 1)
			# Test 2
			# Compute LHS of equation
			lhs = j.jacobianLHS(r, p)
			rhs = j.jacobianRHS(r, p)
			return j.isCongruent(lhs, rhs, p)
		else
			return false
		end

	end

	def isCongruent(b, c, m)
		x = ((b-c)/m)
		return x.is_a?(Integer)
	end

	def jacobianRHS(r, p)
		return r ** ((p-1)/2) % p
		#return r ** ((p-1)/2)
	end

	def jacobianLHS(r, p)
		if(r == 1)
			return 1
		elsif ((r % 2) == 0)
			return jacobianLHS((r/2), p) * (-1)**((p**2 -1)/8)
		elsif ((r % 2) == 1 && r != 1)
			return jacobianLHS((p % r), r) * (-1)**((r-1)*((p-1)/4))
		end
	end
end

# extended Euclid algorithm
def findPrivateKey(b,m,_recursion_depth=0)
	if b % m == 0
		temp = [0,1]
		return temp
	else
		temp = findPrivateKey(m, b % m, _recursion_depth+1)
		temp2 = [temp[1], temp[0]-temp[1] * ((b/m).to_i)]
		if _recursion_depth == 0
			return temp2[0] % m
		else
			return temp2
		end
	end
end
