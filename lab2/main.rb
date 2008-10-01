#!/usr/bin/env ruby -w
# From: http://en.wikipedia.org/wiki/Miller-Rabin_primality_test

input = ARGV[0].to_i

class Integer
   def prime?
     n = self.abs()
     return true if n == 2
     return false if n == 1 || n & 1 == 0

     # cf. http://betterexplained.com/articles/another-look-at-prime-numbers/ and
     # http://everything2.com/index.pl?node_id=1176369

     return false if n > 3 && n % 6 != 1 && n % 6 != 5     # added

     d = n-1
     d >>= 1 while d & 1 == 0
     20.times do                               # 20 = k from above
       a = rand(n-2) + 1
       t = d
       y = ModMath.pow(a,t,n)                  # implemented below
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


class Integer
  def cdiv(d)			# ceil divide
    w=self.divmod(d)
    if w[1] > 0 ;  w[0] +=1 ; end
    return w[0]
  end
  def powm(i,n)	# square-and-multiply for exp modulo n
    if ( i == 0 )
      return 1
    end
    b=1
    a=self

    if ( (i & 1) == 1 )
      b=a
    end
    i = i>>1

    while ( i > 0 )
      a = (a * a) % n
      if ( (i & 1) == 1 )
	b = (a * b) % n 
      end
      i = i>>1
    end
    return b
  end
  def gcd(b)			# GCD
    a = self
    if ( a < b ); t=b; b=a; a=t; end
    while b > 0 
      r = a % b 
      a = b
      b = r
    end
    return a
  end
  def invert(n)  # Extension Euclid Algorithm
    a = n        # See Knuth's The Art of Computer Programming 
    b = self % n # Vol2 pp.342 -- 343  
    p = 0 ; q = 1;  v = 0;  u = 1;
    while q > 0 
      p = a / b
      q =  a % b
      w = v - (p*u)
      ## DEBUG    printf "%d = %d(%d) + %d  (%d)\n", a,p,b,q,v ###
      a = b
      b = q
      v = u
      u = w
    end
    return (v+n) % n
  end

# Miller-Rabin Test  (Prime Test)
# See, http://www.cs.albany.edu/~berg/csi445/Assignments/pa4.html
  def bitarray(n) 
    b=Array::new  
    i=0       
    v=n
    while v > 0
      b[i] = (0x1 & v)
      v = v/2
      i = i + 1
    end
    return b
  end
  def miller_rabin(n,s)
    b=bitarray(n-1)
    i=b.size 
    j =1
    while j <= s
      a = 1 + (rand(n-2).to_i)
      if witness(a,n,i,b) == true
	return false
      end
      j+=1
    end
    return true
  end
  def witness(a,n,i,b)
    d=1
    x=0
    while i > 0 
      x = d 
      d = (d**2) % n
      if ( (d == 1) && (x != 1) && (x != (n-1)) )
	return true
      end
      if ( b[i-1] == 1 )
	d = (d * a ) % n
      end
      i -= 1
    end
    if ( d != 1) 
      return true
    end
    return false
  end

  #def prime?
  def is_prime?
    a = self
    return miller_rabin(a,30)    
  end

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
end


p input.prime?
#p input.is_prime?
