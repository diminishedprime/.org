i := 1
while (i <= 11, i println; i = i + 1); "This one goes up to 11" println

for(i, 1, 11, i println); "This one goes up to 11" println

if(true, "It is true.", "It is false.")
if(false) then("It is true") else("It is false")
if(false) then("It is true." println) else("It is false." println)

OperatorTable

OperatorTable addOperator("xor", 11)

true xor := method(bool, if(bool, false, true))
false xor := method(bool, if(bool, true, false))


postOffice := Object clone
postOffice packageSender := method(call sender)

mailer := Object clone
mailer deliver := method(postOffice packageSender)

mailer deliver

postOffice messageTarget := method(call target)
postOffice messageTarget

postOffice messageArgs := method(call message arguments)
postOffice messageName := method(call message name)

postOffice messageArgs("one", 2, :three)
postOffice messageName


unless := method(
  (call sender doMessage(call message argAt(0))) ifFalse(
    call sender doMessage(call message argAt(1))) ifTrue(
    call sender doMessage(call message argAt(2))))


Object ancestors := method(
  prototype := self proto
  if(prototype != Object,
    writeln("Slots of ", prototype type, "\n---------------")
    prototype slotNames foreach(slotName, writeln(slotName))
    writeln
    prototype ancestors))

Animal := Object clone
Animal speak := method(
  "ambiguous animal noise" println)

Duck := Animal clone
Duck speak := method(
  "quack" println)

Duck walk := method(
  "waddle" println)

disco := Duck clone
disco ancestors


# Day 2 Self-Study

# Do:

# A Fibonacci sequence starts with two 1s. Each subsequent number is the sum of
# the two numbers that came before: 1, 1, 2, 3, 5, 8, 13, 21, and so on. Write a
# program to find the nth Fibonacci number. fib(1) is 1, and fib(4) is 3. As a
# bonus, solve the problem with recursion and with loops.

fib := method(nth,
  g := (5 sqrt + 1) / 2;
  answer := ((g pow(nth)) - ((1-g) pow(nth))) / (5 sqrt);
  return answer floor
)

# How would you change / to return 0 if the denominator is zero?
origDiv := Number getSlot("/")
Number / := method (i,
  if (i != 0, self origDiv(i), 0)
)

# Write a program to add up all of the numbers in a two-dimensional array.
List sum2Dim := method(self map(reduce(+)) reduce(+))


# Add a slot called myAverage to a list that computes the average of all the
# numbers in a list. What happens if there are no numbers in a list? (Bonus:
# Raise an Io exception if any item in the list is not a number.)
List myAverage := method(
  count := self size;
  total := self reduce(acc,a,
    if(a isKindOf(Number),
      a + acc,
      Exception raise("Not a number!")));
  return total / count)

# Write a prototype for a two-dimensional list. The dim(x, y) method should
# allocate a list of y lists that are x elements long. set(x, y, value) should
# set a value, and get(x, y) should return that value.
TwoDimen := clone Object
TwoDimen dim := method(x, y,
  self x := List setSize(x);
  x := x
  self y := List setSize(y))

# Bonus: Write a transpose method so that (new_matrix get(y, x)) == matrix
# get(x, y) on the original list.

# Write the matrix to a file, and read a matrix from a file.

# Write a program that gives you ten tries to guess a random number from 1--100.
# If you would like, give a hint of “hotter” or “colder” after the first guess.