{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module HandleIO
       (
         HandleIO
       , Handle
       , IOMode(..)
       , runHandleIO
       , openFile
       , hClose
       , hPutStrln
       ) where

import System.IO (Handle, IOMode(..))
import qualified System.IO

newtype HandleIO a = HandleIO { runHandleIO :: IO a }
                   deriving Monad

openFile :: FilePath -> IOMode -> HandleIO Handle
openFile path mode = HandleIO $ System.IO.openFile path mode

hClose :: Handle -> HandleIO ()
hClose = HandleIO . System.IO.hClose

hPutStrln :: Handle -> String -> HandleIO ()
hPutStrln h s = HandleIO $ System.IO.hPutStrLn h s

safeHello :: FilePath -> HandleIO ()
safeHello path = do
  h <- openFile path WriteMode
  hPutStrln h "hello world"
  hClose h
