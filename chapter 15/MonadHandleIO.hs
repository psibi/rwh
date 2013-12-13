{-# LANGUAGE FunctionalDependencies, MultiParamTypeClasses #-}

import MonadHandle
import qualified System.IO
import System.IO (IOMode(..))
import System.Directory (removeFile)

instance MonadHandle System.IO.Handle IO where
  openFile = System.IO.openFile
  hPutStr = System.IO.hPutStr
  hClose = System.IO.hClose
  hGetContents = System.IO.hGetContents

safeHello :: MonadHandle h m => FilePath -> m ()
safeHello path = do
  h <- openFile path WriteMode
  hPutStrLn h "hello world"
  hClose h
