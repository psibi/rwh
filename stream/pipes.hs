import Data.Attoparsec.Text
import Pipes
import Pipes.Attoparsec
import Pipes.Text.IO (fromHandle)
import qualified System.IO as IO

type LinkID = Int

data Link = Link {
  lid :: LinkID,
  llength :: Int
  }

data Snap = Snap {
  slid :: LinkID,
  slength :: Int
  }

tab :: Parser Char
tab = char '\t'

linkParser :: Parser Link
linkParser = do
  a <- decimal
  tab
  b <- decimal
  return $ Link a b

snapParser :: Parser Snap
snapParser = do
  a <- decimal
  tab
  b <- decimal
  return $ Snap a b

getLengths :: Monad m => LinkID -> Pipe Link Int m ()
getLengths n = do
  l <- await
  if (lid l > n )
    then yield (llength l)
    else getLengths n

getSnap :: Monad m => Int -> Pipe Snap Snap m ()
getSnap l = do
  s <- await
  if (l == slength s)
    then yield s
    else getSnap l
