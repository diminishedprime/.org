(->>) = flip (.)

mults n = [n, n*2..999]

threes = mults 3
fives = mults 5
both = mults 15

fn = concat
     ->> sum
     ->> subtract (sum both)

result = fn [threes, fives]
