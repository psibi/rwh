#!/usr/bin/env stack
{- stack
     --resolver lts-7.9
     --install-ghc
     runghc
     --package shakespeare
 -}

{-#LANGUAGE QuasiQuotes#-}

import Str
import Data.Time

lng :: String
lng = [str|hello world|]

time2 :: Maybe UTCTime
time2 = [time|2017|]

main :: IO ()
main = do
  print lng
  print time2
