import qualified Data.ByteString as B
import qualified Data.ByteString.Char8 as BC
import Text.HTML.TagSoup

govtHospitalTag = TagText "GOVERNMENT HOSPITALS - CHENNAI"
privateHospitalTag = TagText "PRIVATE HOSPITALS"
privateHospEnd = TagText "Last Updated on 11/2/2011"

data HospitalType = Government | Private
                  deriving (Show)

data Hospital = Hospital {
  hospitalName :: String,
  hospitalAddress :: String,
  hospitalType :: HospitalType,
  hospitalPhone :: Maybe String
  } deriving (Show)

filterUnwanted :: [Tag BC.ByteString] -> [Tag BC.ByteString]
filterUnwanted = filter (pred . fromTagText)
  where pred str = B.length str  >= 4

govtHospitals :: [Tag BC.ByteString] -> [Tag BC.ByteString]
govtHospitals tags = drop 1 $ fst . break (~== privateHospitalTag) $ tags

privateHospitals :: [Tag BC.ByteString] -> [Tag BC.ByteString]
privateHospitals tags = drop 4 $ snd . break (~== privateHospitalTag) $ tags

main :: IO ()
main = do
  content <- B.readFile "hospitals-in-chennai.html"
  let tags = parseTags content
      hospitals = fst . break (~== privateHospEnd) $ snd . break (~== govtHospitalTag) $ tags
      hospitalTagText = filter isTagText hospitals

      refinedTags = filterUnwanted hospitalTagText

      govtTags = govtHospitals refinedTags
      privateTags = privateHospitals refinedTags
      
  putStrLn (show govtTags)
