import Control.Parallel (pseq, par)

forceList :: [a] -> ()
forceList (x:xs) = x `pseq` forceList xs
forceList _ = ()

-- The below example helps you understand how this functon forces
-- every element of a list to be evaluated to WHNF and not NF.

-- ghci> let a = [1..10]
-- ghci> forceList a
-- ()
-- ghci> :sprint a
-- a = [1,2,3,4,5,6,7,8,9,10]   (Here it evaluates to NF)
-- ghci> let a = [[1..10],[2..20]]
-- ghci> forceList a
-- ()
-- ghci> :sprint a
-- a = [(1 : _),(2 : _)]        (Here it evaluates to WHNF)

parallelMap :: (a -> b) -> [a] -> [b]
parallelMap f (x:xs) = let r = f x
                       in r `par` r : parallelMap f xs
parallelMap _ _ = []

stricterMap :: (a -> b) -> [a] -> [b]
stricterMap f xs = forceList xs `seq` map f xs
