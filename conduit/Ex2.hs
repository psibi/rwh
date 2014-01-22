import Data.Conduit
import Control.Monad.IO.Class

sourceList :: Monad m => [a] -> Source m a
sourceList = mapM_ yield 

sink :: Sink String IO () -- Consumes String
sink = awaitForever $ liftIO . putStrLn

myAwaitForever :: Monad m => (a -> Conduit a m b) -> Conduit a m b
myAwaitForever f = do
  mi1 <- await
  case mi1 of
    Just i1 -> f i1 >> myAwaitForever f
    Nothing -> return ()

