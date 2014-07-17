import Control.Monad.ST
import Data.STRef
import Control.Monad

sumST :: Num a => [a] -> a
sumST xs = runST $ do
  n <- newSTRef 0
  forM_ xs $ \x -> do
    modifySTRef n (+ x)

  readSTRef n

foldlST :: (a -> b -> a) -> a -> [b] -> a
foldlST f acc xs = runST $ do
  n <- newSTRef acc
  forM_ xs $ \x -> do
    n' <- readSTRef n
    writeSTRef n (f n' x)

  readSTRef n

