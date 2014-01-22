import Control.Monad.State
import Data.Conduit
import qualified Data.Conduit.List as CL

source :: Source (State Int) Int
source = do
  x <- lift get
  if x <= 0
    then return ()
    else do
      yield x
      lift $ modify (\x -> x - 2)
      source

conduit :: Conduit Int (State Int) (Int, Int)
conduit = awaitForever $ \i -> do
            lift $ modify (+ 1)
            x <- lift get
            yield (i, x)
         
