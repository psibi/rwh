#!/usr/bin/env stack
{- stack
     --resolver lts-9.0
     --install-ghc
     runghc
     --package resourcet
-}

{-# LANGUAGE FlexibleContexts #-}

import Control.Monad.Trans.Resource
import Control.Monad.Trans.Class
import Control.Monad.IO.Class (MonadIO)

bracket ::
  (MonadThrow m, MonadBaseControl IO m,
   MonadIO m) =>
  IO t -> (t -> IO ()) -> (t -> m a) -> m a
bracket alloc free inside = runResourceT $ do
  (releaseKey, resource) <- allocate alloc free
  lift $ inside resource

main :: IO ()
main = bracket
       (putStrLn "Allocating" >> return 5)
       (\i -> putStrLn $ "Freeing: " ++ show i)
       (\i -> putStrLn $ "Using: " ++ show i)
