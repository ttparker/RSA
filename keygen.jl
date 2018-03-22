const L = 653  # max length of plaintext (# of characters)
const e = 65537  # public encryption exponent
const dir = "Data/"  # data directory - must end in /
const publickeyfilename = "TPsPublicKey"  # name of output file to write public key to
const secretkeyfilename = "SecretKey"  # name of output file to write secret key to

####################
const nChars = BigInt(128)  # 128 possible ASCII characters
const pmin = nChars^cld(L, 2)
using Primes

function coprimeTest(x::Integer, y::Integer)  # checks whether x and y are coprime using the Euclidean algorithm
  if x >= y  # set a >= b
    a, b = (x, y)
  else
    a, b = (y, x)
  end
  while b != 0  # a >= b after every iteration
    newsmall = a % b
    a = b
    b = newsmall
  end
  a == 1
end

function randomPrime(primeRange::UnitRange{BigInt})
  p = nextprime(rand(primeRange))
  while !coprimeTest(p - 1, e)  # (p-1) must be coprime with e
    p = nextprime(p + 2)
  end
  p
end

function modinverse(e::Integer, phi::Integer)  # uses the extended Euclidean algorithm to calculate the modular multiplicative inverse of e with respect to phi. I.e. solve (e * d = 1 mod phi) for d, given coprime e and phi. (I don't actually understand this algorithm; I just adapted this code from Wikipedia and it seems to work.)
  r, newr = (phi, e)
  d, newd = (0, 1)
  while newr != 0
    quotient = div(r, newr)
    (d, newd) = (newd, d - quotient * newd)
    (r, newr) = (newr, r - quotient * newr)
  end
  if d < 0
    d += phi
  end
  d
end

# choose distinct primes p and q such that (p-1) and (q-1) are both coprime with e:
p = q = randomPrime(pmin:2*pmin)
while p == q
  q = randomPrime(pmin:2*pmin)
end

# save public key (e and N = p * q):
mkpath(dir)
f = open(dir * publickeyfilename, "w")
println(f, e, "\n", p * q)
close(f)

# save secret key:
f = open(dir * secretkeyfilename, "w")
println(f, modinverse(e, (p - 1) * (q - 1))) # PKCS #1 v2.0 replaces the Euler totient function phi(N) with the Carmichael function, which is more complicated to calculate but slightly smaller, and still makes the algorithm work unchanged.
close(f)
