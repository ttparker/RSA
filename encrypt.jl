const dir = "Data/"  # data directory - must end in /
const plaintextfilename = "Plaintext"  # name of input file containing plaintext
const publickeyfilename = "TPsPublicKey"  # name of input file containing recipient's public key
const ciphertextfilename = "Ciphertext"  # name of output file to write ciphertext to

####################

const nChars = BigInt(128)  # 128 possible ASCII characters
stringToInt(str::String) = sum(i -> BigInt(str[end-i]) * nChars^i, 0:length(str)-1)  # converts plaintext string to an integer

# read in plaintext:
f = open(dir * plaintextfilename, "r")
m = stringToInt(readline(f))
close(f)

# read in public key:
f = open(dir * publickeyfilename, "r")
e = parse(BigInt, readline(f))
N = parse(BigInt, readline(f))
close(f)

# encrypt plaintext:
f = open(dir * ciphertextfilename, "w")
println(f, powermod(m, e, N))
close(f)
