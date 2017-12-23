#!/usr/bin/env stack
{- stack
     --resolver lts-10.0
     --install-ghc
     runghc
     --package conduit
     --package resourcet
-}

{-#LANGUAGE FlexibleContexts#-}

import Data.Conduit
import Data.Conduit.Binary

fileCopy :: FilePath -> FilePath -> IO ()
fileCopy src dst = runConduitRes $ sourceFile src .| sinkFile dst

main :: IO ()
main = do
  writeFile "input.txt" "Hello"
  fileCopy "input.txt" "output.txt"
  readFile "output.txt" >>= putStrLn
