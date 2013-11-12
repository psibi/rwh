----------------------------------------------------------------------
--- Chapter 8: Efficient File processing, Regular Experessions, and
--- Filename Matching
import GlobRegex
import Data.Char(isUpper, toLower, toUpper)

--- Exercise 1

-- ghci > globToRegex "["
-- "^*** Exception: unterminated character class

smallFun :: String -> Int
smallFun = length . globToRegex

-- ghci > smallFun "["
-- *** Exception: unterminated character class

-- Exercise 2

data Case = Sensitive
          | InSensitive

my_globToRegex :: String -> Case -> String
my_globToRegex glob cs = case cs of
  Sensitive -> globToRegex glob
  InSensitive -> globToRegex $ map toUpper glob

my_matchesGlob :: FilePath -> String -> Case -> Bool
my_matchesGlob path glob cs = case cs of
  Sensitive -> matchesGlob path glob
  InSensitive -> matchesGlob (map toUpper path) (map toUpper glob)

