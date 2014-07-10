import           Data.Attoparsec.Text
import           Pipes
import           Pipes.Attoparsec
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

getSnaps :: LinkID -> [Link] -> [Snap] -> [(LinkID, [Snap])]
getSnaps l lks snp = map (\x -> (lid x, filter (\y -> lid x == slid y) snp)) a
  where a = filter (\x -> lid x > l) lks


psnap :: Producer Snap IO ()
psnap = undefined

plink :: Producer Link IO ()
plink = undefined

getLinkIDS :: LinkID -> Pipe Link LinkID IO ()
getLinkIDS l = do
  link <- await
  if (lid link > l)
    then yield (lid link)
    else getLinkIDS l

filteredLinkIDs :: Producer LinkID IO ()
filteredLinkIDs = plink >-> getLinkIDS 3

-- ker :: LinkID -> Pipe Snap Snap IO () -> Pipe Snap Snap IO ()
ker lid  = P.filter (\x -> slid x == lid)
