import qualified Data.ByteString as B
import qualified Data.ByteString.Char8 as BC
import Text.HTML.TagSoup

hospitalNameTag = TagOpen "span" [("style","font-family: Verdana")]

data Hospital = Hospital {
  hospitalName :: String,
  hospitalAddress :: String
  } deriving (Show)

maptoHospital [] = []
maptoHospital (x1:x2:x3:y)
  | BC.length x2 < 20 = x1:(BC.append x2 x3):maptoHospital y
  | otherwise = x1:x2: maptoHospital (x3:y)
maptoHospital (x1:x2) = x1:x2

toHospital :: [(BC.ByteString,BC.ByteString)] -> [Hospital]
toHospital xs = map (\x -> Hospital (BC.unpack (fst x))
                    (BC.unpack (snd x))) xs
  where zipped = toPairs xs

toPairs :: [a] -> [(a,a)]
toPairs [] = []
toPairs (x:[]) = [(x,x)]
toPairs (x:y:xs) = (x,y):toPairs xs

main :: IO ()
main = do
  content <- B.readFile "a.html" 
  let tags = parseTags content
      hospitals = filter (~/= hospitalNameTag) tags
      hospitals2 = filter isTagText hospitals
      hospitals3 = drop 5 $ filter (\x -> unwanted (fromTagText x)) hospitals2

      sanitize = maptoHospital (map fromTagText hospitals3)

      saneNames = toHospital (toPairs sanitize)

      unwanted x = BC.head x /= (BC.head $ BC.pack ("\n"))
                   && BC.length x /= 1
                   && BC.length x /= 2

  putStrLn (show saneNames)
