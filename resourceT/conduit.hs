#!/usr/bin/env stack
{- stack
     --resolver lts-10.0
     --install-ghc
     runghc
     --package resourcet
     --package conduit
     --package directory
-}

{-#LANGUAGE FlexibleContexts#-}
{-#LANGUAGE RankNTypes#-}

import           Control.Monad.IO.Class (liftIO)
import           Control.Monad.Trans.Resource (runResourceT, ResourceT, MonadResource)
import           Data.Conduit           (Producer, Consumer,addCleanup, (.|))
import           Conduit (runConduitRes)
import           Data.Conduit.Binary    (isolate, sinkFile, sourceFile)
import           Data.Conduit.List      (peek)
import           Data.Conduit.Zlib      (gzip)
import           System.Directory       (createDirectoryIfMissing)
import qualified Data.ByteString as B

-- show all of the files we'll read from
infiles :: [String]
infiles = map (\i -> "input/" ++ show i ++ ".bin") [1..10]

-- Generate a filename to write to
outfile :: Int -> String
outfile i = "output/" ++ show i ++ ".gz"

-- Modified sourceFile and sinkFile that print when they are opening and
-- closing file handles, to demonstrate interleaved allocation.
sourceFileTrace :: (MonadResource m) => FilePath -> Producer m B.ByteString
sourceFileTrace fp = do
    liftIO $ putStrLn $ "Opening: " ++ fp
    addCleanup (const $ liftIO $ putStrLn $ "Closing: " ++ fp) (sourceFile fp)

sinkFileTrace :: (MonadResource m) => FilePath -> Consumer B.ByteString m ()
sinkFileTrace fp = do
    liftIO $ putStrLn $ "Opening: " ++ fp
    addCleanup (const $ liftIO $ putStrLn $ "Closing: " ++ fp) (sinkFile fp)

-- Monad instance of Producer allows us to simply mapM_ to create a single Source
-- for reading all of the files sequentially.
source :: (MonadResource m) => Producer m B.ByteString
source = mapM_ sourceFileTrace infiles

-- The Sink is a bit more complicated: we keep reading 30kb chunks of data into
-- new files. We then use peek to check if there is any data left in the
-- stream. If there is, we continue the process.
sink :: (MonadResource m) => Consumer B.ByteString m ()
sink =
    loop 1
  where
    loop i = do
        isolate (30 * 1024) .| sinkFileTrace (outfile i)
        mx <- peek
        case mx of
            Nothing -> return ()
            Just _ -> loop (i + 1)

fillRandom :: FilePath -> IO ()
fillRandom fp = runConduitRes $ 
                sourceFile "/dev/urandom" 
                .| isolate (50 * 1024) 
                .| sinkFile fp

-- Putting it all together is trivial. ResourceT guarantees we have exception
-- safety.
transform :: IO ()
transform = runConduitRes $ source .| gzip .| sink
-- /show

-- Just some setup for running our test.
main :: IO ()
main = do
    createDirectoryIfMissing True "input"
    createDirectoryIfMissing True "output"
    mapM_ fillRandom infiles
    transform
