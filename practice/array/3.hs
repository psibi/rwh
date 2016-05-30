import qualified Data.ByteString as B
import qualified Data.ByteString.Char8 as BC
import Data.Sequence
import qualified Data.Sequence as S
import Data.ByteString.Char8 (readInt)
import Data.Maybe (fromJust)
import Data.Bits (xor)

calculateIndex :: Int -> Int -> Int -> Int
calculateIndex x lastAns n = ((x `xor` lastAns) `mod` n)

replaceIndex :: Int -> a -> Seq a -> Seq a
replaceIndex index item xs = S.update index item xs

queryOne ::  Int -> Int -> Seq (Seq Int) -> Int -> Int -> Seq (Seq Int)
queryOne n lastAns seq x y = let index = calculateIndex x lastAns n
                                 item = (seq `S.index` index) |> y
                             in replaceIndex index item seq

queryTwo :: Int -> Int -> Seq (Seq Int) -> Int -> Int -> IO (Seq (Seq Int), Int)
queryTwo n lastAns seq x y = do
    let index = calculateIndex x lastAns n
        item = (seq `S.index` index)
        lastAns' = item `S.index` (y `mod` S.length item) 
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

processQuery :: Int -> Int -> Int -> Seq (Seq Int) -> IO ()
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
  let seq =  S.replicate n (S.empty) :: (Seq (Seq a))
  processQuery n q 0 seq
