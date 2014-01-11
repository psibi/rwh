import Control.Monad
import Data.Char

data Parsed = Digit Integer | Hex Integer | Word String deriving Show

parseHexDigit :: Parsed -> Char -> [Parsed]
parseHexDigit (Hex n) c = if isHexDigit c
                          then return (Hex ((n*16) + (toInteger (digitToInt c))))
                          else mzero
parseHexDigit _ _        = mzero
                               
parseDigit :: Parsed -> Char -> [Parsed]
parseDigit (Digit n) c = if isDigit c
                         then return (Digit ((n*10) + (toInteger (digitToInt c))))
                         else mzero
parseDigit _ _ = mzero

parseWord :: Parsed -> Char -> [Parsed]
parseWord (Word s) c = if isAlpha c
                       then return (Word (s ++ [c]))
                       else mzero
parseWord _ _ = mzero

parse :: Parsed -> Char -> [Parsed]
parse p c = (parseHexDigit p c) `mplus` (parseDigit p c) `mplus` (parseWord p c)

