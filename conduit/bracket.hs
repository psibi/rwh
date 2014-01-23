import System.IO
import Data.Conduit
import Control.Monad.IO.Class
import qualified Data.Conduit.List as CL

source =
    bracketP
    (openFile "fileIO.hs" ReadMode) 
    (\handle -> putStrLn "Closing handle" >> hClose handle) loop
    where
      loop handle = do
        eof <- liftIO $ hIsEOF handle
        if eof
        then return ()
        else do
          c <- liftIO $ hGetChar handle
          yield c
          loop handle

exceptionalSink = do
  c <- await
  liftIO $ print c
  error "This throws an exception"

main = runResourceT $ source $$ exceptionalSink
