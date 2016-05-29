{-#LANGUAGE OverloadedStrings#-}

import qualified Data.ByteString as B
import qualified Data.ByteString.Char8 as BC
import qualified Data.Vector as V
import Data.ByteString.Char8 (readInt)
import Data.Maybe (fromJust)

getInitialData :: IO (Int, V.Vector B.ByteString)
getInitialData = do
  firstLine <- B.getLine
  let x = fst $ fromJust $ readInt firstLine
  secondLine <- B.getLine
  let y = V.fromList $ BC.split ' ' secondLine
  return (x,y)

main :: IO ()
main = do
  (n, vec) <- getInitialData
  let vec' = V.reverse vec
  V.mapM_ (\x -> B.putStr x >> B.putStr " ") vec'

    

