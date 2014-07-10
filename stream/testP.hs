import           Control.Applicative ((<*))
import           Control.Monad (liftM)
import           Data.Attoparsec.Text
import           Pipes
import           Pipes.Attoparsec (parsed, ParsingError)
import qualified Pipes.Prelude as P
import           Pipes.Text.IO (fromHandle)
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
                
getSnap
  :: Monad m
  => Int
  -> Producer Link m r
  -> Producer Snap m r
  -> Producer (LinkID, [Snap]) m r
getSnap n lks snp = do
  snp' <- lift (P.toListM (snp >> return ()))
  lks >-> P.filter (\x -> lid x > n)
        >-> P.map (\x -> (lid x, filter (\y -> lid x == slid y) snp'))

drawData :: (LinkID, [Snap]) -> IO ()
drawData = undefined
 
linkFile = "some file path"
snapshotFile = "some file path"
 
parseLink :: Parser Link
parseLink = undefined
 
snapshotParser :: Parser Snap
snapshotParser = undefined

main = IO.withFile linkFile IO.ReadMode $ \linkHandle ->
  IO.withFile snapshotFile IO.ReadMode $ \snapHandle -> runEffect $
  for (getSnap 2 (parsed (parseLink <* endOfLine) (fromHandle linkHandle))
       (parsed (snapshotParser <* endOfLine) (fromHandle snapHandle))) $ \d ->
  lift (drawData d)

