#!/usr/bin/env stack
{- stack
     --resolver lts-10.0
     --install-ghc
     runghc
     --package conduit
-}

import Data.Conduit
import Data.Conduit.Binary
import System.IO

fileCopy :: FilePath -> FilePath -> IO ()
fileCopy src dst = withFile src ReadMode $ \srcH ->
                   withFile dst WriteMode $ \dstH ->
                   sourceHandle srcH $$ sinkHandle dstH

main :: IO ()
main = do
    writeFile "input.txt" "Hello"
    fileCopy "input.txt" "output.txt"
    readFile "output.txt" >>= putStrLn
