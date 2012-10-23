{-# LANGUAGE FlexibleContexts #-}

import MyMonad
import Prelude hiding (Monad,return)
  
class Monad m => MonadProb m where
  choice :: (Fractional b, Ord b) => b -> m a -> m a -> m a
  choice p x y = if p < (1-p) then y else x

instance MonadProb [] where

length1 :: Fractional b => [a] -> b
length1 [] = 0.0
length1 (x:xs) = 1.0 + (length1 xs)

uniform :: [a] -> [a]
uniform [x] = return x
uniform (x:xs) = choice (1/length1 (x:xs)) (return x) (uniform xs)

--| THE MONTY HALL PROBLEM
data Door = A | B | C deriving (Eq, Show)

doors :: [Door]
doors = [A,B,C]

--| Hiding the car behind one door ramdonly
hide :: [Door]
hide = uniform doors

--| Selecting one door ramdonly
pick :: [Door]
pick = uniform doors

(\\) :: Eq a => [a] -> [a] -> [a]
[] \\ _ = []
x \\ y = [a | a <- x, a `notElem` y]

--| Opening one door to reveal a goat
tease :: Door -> Door -> [Door]
tease h p = uniform (doors \\ [h,p])

--| Switching the original choice
switch :: Door -> Door -> [Door]
switch p t = return (head (doors \\ [p,t]))

--| Staying in the original choice
stick :: Door -> Door -> [Door]
stick p t = return p

play :: (Door -> Door -> [Door]) -> [Bool]
play strategy = do
  h <- hide
  p <- pick
  t <- tease h p
  s <- strategy p t
  return (s == h)
  
--| Cartesian Product