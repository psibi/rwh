import Text.ParserCombinators.Parsec
import Control.Applicative hiding ((<|>))
import Control.Monad

data Test = Test Integer Double deriving Show

integer :: Parser Integer
integer = rd <$> many1 digit
    where rd = read :: String -> Integer

positiveFloat :: Parser Double
positiveFloat = do
  a <- many1 digit
  char '.'
  b <- many1 digit
  return $ rd (a ++ "." ++ b)
    where rd = read :: String -> Double
          
testParser :: Parser Test
testParser = do
  a <- integer
  char ','
  b <- positiveFloat
  return $ Test a b

testParserFile = manyTill anyChar newline *> endBy testParser eol
  
eol :: Parser Char
eol = char '\n'

main = do
  a <- parseFromFile testParserFile "./jack.txt"
  print a
