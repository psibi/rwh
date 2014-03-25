import Control.Monad

newtype Parser a = Parser (String -> [(a, String)])

item :: Parser Char
item = Parser (\cs -> case cs of
                  "" -> []     
                  (c:cs) -> [(c,cs)])

parse :: Parser a -> String -> [(a, String)]
parse (Parser p) = p

instance Monad Parser where
  return a = Parser (\cs -> [(a,cs)])
  p >>= f = Parser (\cs -> concat [parse (f a) cs' | (a, cs') <- parse p cs])

-- (>>=) :: Parser a -> (a -> Parser b) -> Parser b            
