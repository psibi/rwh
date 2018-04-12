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
import           Data.ByteString.Builder  (Builder, byteString)
import           Network.HTTP.Types       (status200)
import           Network.Wai              (Application, responseBuilder)
import           Network.Wai.Handler.Warp (run)

main :: IO ()
main = run 3000 app

app :: Application
app _req sendResponse = sendResponse $ responseBuilder
    status200
    [("Content-Type", "text/plain")]
    (byteString "Hello from blaze-builder!" :: Builder)
