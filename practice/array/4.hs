-- Sparse array problem

import Data.Sequence (Seq)
import qualified Data.Sequence as S
import Data.ByteString (ByteString)
import Data.Maybe (fromJust)
import qualified Data.ByteString as B
import qualified Data.ByteString.Char8 as BC

fastInt :: B.ByteString -> Int
fastInt bc = fst $ fromJust $ BC.readInt bc

getStringData :: Int -> IO (Seq ByteString)
getStringData n = aux n S.empty
    where
      aux :: Int -> Seq ByteString -> IO (Seq ByteString)
      aux n seq = case n of
                    0 -> return seq
                    x -> do
                      dat <- B.getLine
                      aux (x - 1) (seq S.|> dat)
  
getInitialData :: IO (Seq ByteString, Int)
getInitialData = do
  firstLine <- B.getLine
  let n = fastInt firstLine
  xs <- getStringData n
  noQuery <- B.getLine
  let q = fastInt noQuery
  return (xs, q)

processQuery :: Int -> Seq ByteString -> IO ()
processQuery n seq = case n of
                       0 -> return ()
                       x -> do
                         queryData <- B.getLine
                         let seq' = S.filter (== queryData) seq
                         print $ S.length seq'
                         processQuery (x - 1) seq
  

main :: IO ()
main = do
  (seq, q) <- getInitialData
  processQuery q seq
