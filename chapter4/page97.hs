--- Chapter 4: Functional Programming
-- Exercise 1, 2 & 3

import Data.Char (digitToInt,
                  isDigit)
import Data.List (foldl')

asInt_fold :: String -> Int
asInt_fold ('-':xs) = negate $ asInt_fold xs
asInt_fold xs = foldl' step 0 xs
  where step acc x = (acc * 10) + (digitToInt x)

-- Exercise 4

type ErrorMessage = String

check_char :: String -> Maybe Char
check_char xs = foldr step Nothing xs
  where step x acc = case acc of Just y -> acc
                                 _ -> if isDigit x
                                      then Nothing
                                      else Just x


asInt_either :: String -> Either ErrorMessage Int
asInt_either xs = case (check_char xs)
                  of Nothing -> Right (asInt_fold xs)
                     Just x -> Left ("non-digit " ++ [x])

-- Exercise 5 & 6

my_concat :: [[a]] -> [a]
my_concat xs = foldr step [] xs
  where step x acc = x ++ acc

-- Exercise 7

my_takeWhile :: (a -> Bool) -> [a] -> [a]
my_takeWhile p x = aux p x []
  where aux _ [] acc = reverse acc
        aux p (x:xs) acc = if p x
                           then aux p xs (x:acc)
                           else reverse acc

my_takeWhile' :: (a -> Bool) -> [a] -> [a]
my_takeWhile' p xs = foldr step [] xs
  where step x acc = if p x
                     then x:acc
                     else []

-- Todo: Exercise 8, 9 & 10



