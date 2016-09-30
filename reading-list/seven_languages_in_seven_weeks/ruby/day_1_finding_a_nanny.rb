# Print the string, Hello, world!
(puts 'Hello, world!')

# For the string "Hello, Ruby," find the index of the word "Ruby."
'Hello, Ruby'.index('Ruby')

# Print your name ten times.
10.times do
  puts 'Your name'
end

# Print the string "This is sentence number 1," where the number 1 changes from
# 1 to 10.
11.times do |x|
  puts "This is sentence number #{x}"
end

# Run a Ruby program from a file. (This is sorta what I'm doing right now...)

# Bonus problem: If you're feeling the need for a little more, write a program
# that picks a random number. Let a player guess the number, telling the player
# whether the guess is too low or too high.

# (Hint: rand(10) will generate a random number from 0 to 9, and gets will read
# a string from the keyboard that you can translate to an integer.)

def guess_a_number
  random_num = rand(10)
  guessed_correctly = false
  until guessed_correctly
    puts 'Try to guess the number!'
    guess = gets
    guess_as_number = guess.to_i
    if guess_as_number == random_num
      puts 'You guessed correctly!'
      guessed_correctly = true
    else puts 'Try again!'
    end
  end
end
