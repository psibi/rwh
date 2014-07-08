import           Control.Exception (try, throwIO)
import           Control.Monad (unless, replicateM_)
import qualified GHC.IO.Exception as G
import           Pipes
import           Prelude hiding (take)
import           System.IO (isEOF)

stdinLn :: Producer String IO ()
stdinLn = do
  eof <- lift isEOF
  unless eof $ do
    str <- lift getLine
    yield str
    stdinLn

loop :: Effect IO ()
loop = for stdinLn $ \str -> do
  lift $ putStrLn str

duplicate :: Monad m => a -> Producer a m ()
duplicate x = do
  yield x
  yield x
  
loop2 :: Producer String IO ()
loop2 = for stdinLn duplicate

testLoop2 = runEffect $ for loop2 (lift . print)

stdoutLn :: Consumer String IO ()
stdoutLn = do
  str <- await
  x <- lift $ try $ putStrLn str
  case x of
    Left e@(G.IOError { G.ioe_type = t}) ->
      lift $ unless (t == G.ResourceVanished) $ throwIO e
    Right () -> stdoutLn

doubleUp :: Monad m => Consumer String m String
doubleUp = do
  str1 <- await
  str2 <- await
  return $ str1 ++ str2

demoDouble = runEffect $ lift getLine  >~ doubleUp >~ stdoutLn

anotherDemo = runEffect $ stdinLn >-> stdoutLn

take :: Monad m => Int -> Pipe a a m ()
take n = do
  replicateM_ n $ do
    x <- await
    yield x

maxInput :: Int -> Producer String IO ()
maxInput n = stdinLn >-> take n

