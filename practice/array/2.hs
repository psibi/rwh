import qualified Data.ByteString as B
import qualified Data.ByteString.Char8 as BC
import Data.ByteString.Char8 (readInt)
import Data.Maybe (fromJust)
import Data.List (foldl1')

-- 2D Array - DS

fastInt :: B.ByteString -> Int
fastInt bc = fst $ fromJust $ readInt bc

getInitialData :: IO [[Int]]
getInitialData = aux 6 []
    where
      aux :: Int -> [[Int]] -> IO [[Int]]
      aux n xs = case n of
                   0 -> return xs
                   x -> do
                     row <- B.getLine
                     let row' = map fastInt $ BC.split ' ' row
                     aux (x - 1) (xs ++ [row'])

isHourGlass :: [Int] -- Size is 3x3
            -> Bool
isHourGlass xs = any (/= 0)  xs

-- Need to generate 24 hourglasses
--extract3x3 :: [[Int]] -> [[Int]]
extract3x3 :: [[Int]] -> [[[[Int]]]]
extract3x3 xs = let rows = map (\x -> map (\y -> take 3 $ drop y x) [0..3]) xs
                in map (\x -> take 3 $drop x rows ) [0..3]

(!!!) :: Num b => [b] -> [b] -> [b]
(!!!) xs ys = map (\(a,b) -> a + b) (zip xs ys)


-- phase2 :: [[[[Int]]]] -> [[Int]]
-- phase2 xs = let y = map (\x -> map (map sum) x) xs
--             in foldl1' (\a b -> a !!! b) y

-- main :: IO ()
-- main = do
--   hglass <- getInitialData
--   let xs = extract3x3 hglass
--       ys = phase2 xs
--   return ()
  -- print $ max ys
