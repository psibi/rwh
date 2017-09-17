{-#LANGUAGE DeriveGeneric#-}
{-#LANGUAGE OverloadedStrings#-}

import Dhall

data Example = Example { foo :: Integer, bar :: Vector Double} deriving (Generic, Show)

instance Interpret Example

main :: IO ()
main = do
  x <- input auto "./config"
  print (x :: Example)
