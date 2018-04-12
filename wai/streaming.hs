#!/usr/bin/env stack
{- stack
     --resolver lts-11.4
     --install-ghc
     runghc
     --package bytestring
     --package warp
     --package wai
 -}

{-# LANGUAGE OverloadedStrings #-}

import Data.ByteString.Builder  (Builder, byteString)
import Blaze.ByteString.Builder.Char.Utf8 (fromShow)
import Control.Concurrent (threadDelay)
import Control.Monad (forM_)
import Control.Monad.Trans.Class (lift)
import Data.Monoid ((<>))
import Network.HTTP.Types (status200)
import Network.Wai (Application, responseStream)
import Network.Wai.Handler.Warp (run)

main :: IO ()
main = run 3000 app

app :: Application
app _req sendResponse =
  sendResponse $ responseStream status200 [("Content-Type", "text/plain")] myStream

myStream :: (Builder -> IO ()) -> IO () -> IO ()
myStream send flush = do
  send $ byteString "Starting streaming response.\n"
  send $ byteString "Performing some I/O.\n"
  flush
  -- pretend we're performing some I/O
  threadDelay 5000000
  send $ byteString "I/O performed, here are some results.\n"
  flush
  forM_ [1 .. 50 :: Int] $
    \i -> do
      send $
        byteString "Got the value: " <> fromShow i <> byteString "\n"
