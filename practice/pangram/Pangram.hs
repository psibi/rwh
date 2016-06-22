import Data.Char (toUpper)

isPangram :: String -> Bool
isPangram str = aux str range
    where
      range = ['A'..'Z']
      
      aux :: String -> String -> Bool
      aux _ [] = True
      aux [] xs = False
      aux (x:xs) ys = aux xs (removeChar (toUpper x) ys)

removeChar :: Char -> String -> String
removeChar _ [] = []
removeChar c (x:xs) = if (c == x)
                      then xs
                      else (x:removeChar (toUpper c) xs)

main :: IO ()
main = do
  str <- getLine
  if (isPangram str)
  then putStrLn "pangram"
  else putStrLn "not pangram"
  
