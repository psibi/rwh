{-# LANGUAGE RecordWildCards #-}

import Arbitrary
import System.Exit
import System.Environment
import Test.QuickCheck
import Test.QuickCheck.All

import File_Some -- The file where prop_tests are present


rigorous :: Args
rigorous = Args
    { replay = Nothing
    , maxSuccess = 1000 -- tests to run
    , maxDiscardRatio = 1000
    , maxSize = 1000 -- if a prop_ function uses a list ([]) type, maxSize is the max length of the randomly generated list
    , chatty = True
    }
 
-- Quick test arguments.
quick :: Args
quick = Args
    { replay = Nothing
    , maxSuccess = 100
    , maxDiscardRatio = 100
    , maxSize = 100
    , chatty = True
    }
 
runTests :: [String] -> IO ()
runTests as = case as of
    [] -> runTests' quick
    a -> case head a of
        "1" -> runTests' quick
        "2" -> runTests' rigorous
        _ -> runTests' quick
    where
    runTests' :: Args -> IO ()
    runTests' testArgs = do
        -- if all of your prop_ functions are of the same type, you can put
        -- them in a list and use mapM_ instead
        f prop_fun_name "prop_fun_name"
        where
        f prop str = do
            putStrLn str
            quitOnFail =<< quickCheckWithResult testArgs prop
        quitOnFail r = case r of
            -- pattern match with just two dots with RecordWildCards because I'm lazy
            Success{..} -> return ()
            _ -> exitFailure
 
main :: IO ()
main = getArgs >>= runTests

