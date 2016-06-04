-- Exercise: Ask

-- Implement the following function. If you get stuck, remember it’s less
-- complicated than it looks. Write down what you know. What do you know about
-- the type 𝑎? What does the type simplify to? How many inhabitants does that
-- type have? You’ve seen the type before.

newtype Reader r a =
  Reader { runReader :: r -> a }

ask :: Reader a a
ask = Reader id
