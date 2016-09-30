"Hi Ho, Io" print

Vehicle := Object clone

Vehicle description := "Something to take you far away"

Vehicle slotNames

Car := Vehicle clone
Car slotNames
Car type

ferrari := Car clone
ferrari slotNames
ferrari type

Ferrari := Car clone
Ferrari type
Ferrari slotNames
ferrari slotNames

method("So, you've come for an argument." println)

Car drive := method("Vroom!" println)

ferrari getSlot("drive")
ferrari getSlot("type")
ferrari proto

Car proto

Lobby

toDos := list("find my car", "find Continuum Transfunctioner")
toDos size
toDos reverse
toDos map(println)
toDos map(method("hi" println))

list(1, 2, 3, 4)

list(1, 2, 3, 4) average

elvis := Map clone
elvis atPut("home", "Graceland")
elvis at("home")
elvis atPut("hometown", "Tupelo")
elvis asList
elvis size


4 < 5
true and false
true and true
true and 0

# You make a singleton by overrind the clone slot
Highlander := Object clone
Highlander clone := Highlander

# When using singletons, all clones will be identical.
fred := Highlander clone
mike := Highlander clone
fred == mike

# This is not the general case
one := Object clone
two := Object clone
one == two

# A singleton will always edit the same object.
mike description := "I am mike"
mike description
fred description


# Exercises
# Answer:

# Evaluate 1 + 1 and then 1 + "one". Is Io strongly typed or weakly typed?
# Support your answer with code.
1 + 1
# 1 + "one"  This doesn't work because argument to + has to be a number.

# Is 0 true or false? What about the empty string? Is nil true or false? Support
# your answer with code.
# 0 and "" are true
0 and true
"" and true

# nil is falsey
nil and true

# How can you tell what slots a prototype supports?

## by calling the slotNames on it?

# What is the difference between = (equals), := (colon equals), and ::= (colon
# colon equals)? When would you use each one?

## = assigns to an existing slot
## := creates and assigns to an existing slot

# Do:
# Run an Io program from a file.
## see ./simple_script

# Execute the code in a slot given its name.
ferrari getSlot("drive") call