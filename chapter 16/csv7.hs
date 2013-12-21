import Text.ParserCombinators.Parsec

csvFile = endBy line eol
line = sepBy cells (char ',')
cells = many (noneOf ",\n\r")

eol = try (string "\n\r")
      <|> try (string "\r\n")
      <|> string "\n"
      <|> string "\r"
      <|> fail "Couldn't find EOL"

parseCSV :: String -> Either ParseError [[String]]
parseCSV input = parse csvFile "(unkown)" input
