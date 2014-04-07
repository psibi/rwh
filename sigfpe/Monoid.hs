import Data.Monoid
import Data.Foldable
import Control.Monad.State
import Control.Monad.Writer

fact1 :: Integer -> Writer String Integer
fact1 0 = return 1
fact1 n = do
  let n' = n - 1
  tell $ "We have taken one away from " ++ show n ++ "\n"
  m <- fact1 n'
  tell $ "We have  called f " ++ show m ++ "\n"
  let r = n * m
  tell $ "We've multiplied " ++ show n ++ " add " ++ show m ++ "\n"
  return r
