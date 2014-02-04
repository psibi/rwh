{-# LANGUAGE ScopedTypeVariables #-}

import Control.Concurrent (MVar, putMVar, takeMVar)
import Control.Exception (block, catch, throw, unblock, SomeException)
import Prelude hiding (catch)

modifyMVar :: MVar a -> (a -> IO (a,b)) -> IO b
modifyMVar m io =
  block $ do
    a <- takeMVar m
    (b,r) <- unblock (io a) `catch` \(e :: SomeException) ->
      putMVar m a >> throw e
    putMVar m b
    return r
    
