-- Intermission: Exercises

-- Given the following datatype, answer the following questions:

data Mood = Blah | Woot deriving Show
-- 1. What is the type constructor, or name of this type?

-- Mood

-- 2. If the function requires a Mood value, what are the values you could possibly use there?

-- Blah, or Woot

-- 3. We are trying to write a function changeMood to change Chris’s mood
-- instantaneously. So far, we’ve written a type signature

-- changeMood :: Mood -> Woot.

-- What’s wrong with that?

-- This type signature requires that you always return Woot no matter what. This
-- doesn't enable you to ever return Blah.

-- 4. Now we want to write the function that changes his mood. Given an input
-- mood, it gives us the other one. Fix any mistakes and complete the function:
changeMood Blah = Woot
changeMood    _ = Blah

-- 5. Enter all of the above — datatype (including the “deriving Show” bit),
-- your corrected type signature, and the corrected function into a source file.
-- Load it and run it in GHCi to make sure you got it right.
