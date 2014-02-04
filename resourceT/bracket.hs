import Control.Exception (bracket)

-- See type of bracket do understand it more clearly.

main = do
    bracket
        (do
            putStrLn "Enter some number"
            readLn)
        (\i -> putStrLn $ "Freeing scarce resource: " ++ show i)
        doSomethingDangerous
    somethingElse
    
doSomethingDangerous i =
    putStrLn $ "5 divided by " ++ show i ++ " is " ++ show (5 `div` i)
    
somethingElse = putStrLn
    "This could take a long time, don't delay releasing the resource!"
