#!/usr/bin/env stack
{- stack
     --resolver lts-9.0
     --install-ghc
     runghc
     --package resourcet
-}

import Control.Exception (bracket)

-- See type of bracket do understand it more clearly.
-- bracket
--   :: IO Integer -> (Integer -> IO ()) -> (Integer -> IO ()) -> IO ()

main :: IO ()
main = do
    bracket
        (do
            putStrLn "Enter some number"
            readLn)
        (\i -> putStrLn $ "Freeing scarce resource: " ++ show i)
        doSomethingDangerous
    somethingElse

doSomethingDangerous :: Int -> IO ()    
doSomethingDangerous i =
    putStrLn $ "5 divided by " ++ show i ++ " is " ++ show (5 `div` i)

somethingElse :: IO ()    
somethingElse = putStrLn
    "This could take a long time, don't delay releasing the resource!"
