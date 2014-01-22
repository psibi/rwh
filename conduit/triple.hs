import Data.Conduit
import qualified Data.Conduit.List as CL

triple = do
  ma <- await
  case ma of
    Nothing -> return ()
    Just a -> do
      CL.sourceList [a, a, a]
      triple
