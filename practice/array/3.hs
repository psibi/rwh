import qualified Data.ByteString as B
import qualified Data.ByteString.Char8 as BC
import qualified Data.Vector as V
import Data.ByteString.Char8 (readInt)
import Data.Maybe (fromJust)
import Data.Bits (xor)

calculateIndex :: Int -> Int -> Int -> Int
calculateIndex x lastAns n = ((x `xor` lastAns) `mod` n)

replaceIndex :: Int -> a -> V.Vector a -> V.Vector a
replaceIndex index item xs = xs V.// [(index, item)]

queryOne ::  Int -> Int -> V.Vector (V.Vector Int) -> Int -> Int -> V.Vector (V.Vector Int)
queryOne n lastAns seq x y = let index = calculateIndex x lastAns n
                                 item = (seq V.! index) `V.snoc` y
                             in replaceIndex index item seq

queryTwo :: Int -> Int -> V.Vector (V.Vector Int) -> Int -> Int -> IO (V.Vector (V.Vector Int), Int)
queryTwo n lastAns seq x y = do
    let index = calculateIndex x lastAns n
        item = (seq V.! index)
        lastAns' = item V.! (y `mod` V.length item) 
    print lastAns'
    return (replaceIndex index item seq, lastAns')

fastInt :: B.ByteString -> Int
fastInt bc = fst $ fromJust $ readInt bc

getInitialData :: IO (Int, Int)
getInitialData = do
  firstLine <- B.getLine
  let fLine = map fastInt $ BC.split ' ' firstLine
      n = fLine !! 0
      q = fLine !! 1
  return (n,q)

getQuery :: IO [Int]
getQuery = do
  firstLine <- B.getLine
  let fLine = map fastInt $ BC.split ' ' firstLine
  return fLine

processQuery :: Int -> Int -> Int -> V.Vector (V.Vector Int) -> IO ()
processQuery n q lastAns seq = if (q == 0)
                               then return ()
                               else
                                   do
                                     [queryType,x,y] <- getQuery
                                     if (queryType == 1)
                                     then 
                                         do
                                           let seq' = queryOne n lastAns seq x y
                                           processQuery n (q - 1) lastAns seq'
                                     else 
                                         do
                                           (seq', lastAns') <- queryTwo n lastAns seq x y
                                           processQuery n (q - 1) lastAns' seq'

main :: IO ()
main = do
  (n,q) <- getInitialData
  let seq = V.generate 10 (\x -> V.empty) :: V.Vector (V.Vector Int)
  processQuery n q 0 seq
