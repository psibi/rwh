import Data.Conduit
import qualified Data.Conduit.List as CL

triple :: Monad m => Conduit a m a
triple = do
  ma <- await
  case ma of
    Nothing -> return ()
    Just a -> do
      CL.sourceList [a, a, a]
      triple

--- Mini Exercise
mytriple :: Monad m => Conduit a m a
mytriple = awaitForever $ \i -> do
             CL.sourceList [i, i, i]

--- Exercise
conduit :: Conduit Int IO Int
conduit = do
  ma <- await
  case ma of
    Nothing -> return ()
    Just a -> CL.map (* a)

main = CL.sourceList [1..4] $$ mytriple =$ CL.mapM_ print
