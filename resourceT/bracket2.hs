-- Implementing bracket in terms of ResouceT

import Control.Monad.Trans.Resource
import Control.Monad.Trans.Class

bracket alloc free inside = runResourceT $ do
  (releaseKey, resource) <- allocate alloc free
  lift $ inside resource

main = bracket
       (putStrLn "Allocating" >> return 5)
       (\i -> putStrLn $ "Freeing: " ++ show i)
       (\i -> putStrLn $ "Using: " ++ show i)
