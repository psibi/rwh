#!/usr/bin/env stack
{- stack
     --resolver lts-6.15
     --install-ghc
     runghc
     --package shakespeare
 -}

{-#LANGUAGE QuasiQuotes#-}

import Str

lng :: String
lng = [str|hello world|]

main :: IO ()
main = print lng
