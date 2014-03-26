import Text.ParserCombinators.Parsec
import Control.Applicative hiding ((<|>))
import Control.Monad

data Test = Test Integer Integer deriving Show

integer :: Parser Integer
integer = rd <$> many1 digit
    where rd = read :: String -> Integer
          
testParser :: Parser Test
testParser = do
  a <- integer
  char ','
  b <- integer
  eol
  return $ Test a b

eol :: Parser Char
eol = char '\n'

main = do
  a <- parseFromFile testParser "./jack.txt"
  print a
