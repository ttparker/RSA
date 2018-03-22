const dir = "Data/"  # data directory - must end in /
const publickeyfilename = "TPsPublicKey"  # name of input file containing public key
const secretkeyfilename = "SecretKey"  # name of input file containing secret key
const ciphertextfilename = "Ciphertext"  # name of input file containing ciphertext
const decryptedfilename = "Decrypted"  # name of output file to save deciphered plaintext to

####################

const nChars = BigInt(128)  # 128 possible ASCII characters
function intToString(m::BigInt)  # converts decrypted integer m back to plaintext
  chars = Char[]
  for n in div(ceil(Int, log2(m)), 7)-1:-1:0
    d, m = divrem(m, nChars^n)
    push!(chars, d)
  end
  String(chars)
end

# read in public key:
f = open(dir * publickeyfilename, "r")
readline(f)  # don't need e
N = parse(BigInt, readline(f))
close(f)

# read in secret key:
f = open(dir * secretkeyfilename, "r")
d = parse(BigInt, readline(f))
close(f)

# read in ciphertext:
f = open(dir * ciphertextfilename, "r")
c = parse(BigInt, readline(f))
close(f)

# decrypt ciphertext:
f = open(dir * decryptedfilename, "w")
println(f, intToString(powermod(c, d, N)))
close(f)
