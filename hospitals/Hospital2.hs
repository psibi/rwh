{-# LANGUAGE OverloadedStrings #-}

import qualified Data.ByteString as B
import qualified Data.ByteString.Char8 as BC
import Text.HTML.TagSoup
import Data.String.Utils (lstrip)
import Data.List (isPrefixOf)
import System.IO
import Data.Aeson

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

instance ToJSON HospitalType where
  toJSON (Government) = undefined

instance ToJSON Hospital where
  toJSON (Hospital hospitalName hospitalAddress hospitalType hospitalPhone) =
    object [ "hospitalName" .= hospitalName
           , "hospitalAddress" .= hospitalAddress
           , "hospitalType" .= hospitalType
           , "hospitalPhone" .= hospitalPhone ]

filterUnwanted :: [Tag BC.ByteString] -> [Tag BC.ByteString]
filterUnwanted = filter (pred . fromTagText)
  where pred str = B.length str  >= 5

govtHospitals :: [Tag BC.ByteString] -> [Tag BC.ByteString]
govtHospitals tags = drop 1 $ fst . break (~== privateHospitalTag) $ tags

privateHospitals :: [Tag BC.ByteString] -> [Tag BC.ByteString]
privateHospitals tags = drop 4 $ snd . break (~== privateHospitalTag) $ tags

govttoHospital :: [String] -> [Hospital]
govttoHospital [] = []
govttoHospital (x1:x2:x3:x4) = if isPrefixOf "Phone" x3
                               then (Hospital x1 x2 Government (Just x3)):govttoHospital x4
                               else govttoHospital $ (x1 ++ x2):x3:x4

privatetoHospitals :: [String] -> [Hospital]
privatetoHospitals [] = []
privatetoHospitals (x1:x2:x3) = (Hospital x1 x2 Private Nothing):
                                privatetoHospitals x3

removeQuotes :: String -> String
removeQuotes str = filter (/= '\"') str

-- writeToFile :: FilePath -> [Hospital] -> IO ()
-- writeToFile fname hospitals = withFile fname WriteMode $ \handle -> do
--   let Shospitals = map hospitals

main :: IO ()
main = do
  content <- B.readFile "hospitals-in-chennai.html"
  let tags = parseTags content
      hospitals = fst . break (~== privateHospEnd) $ snd . break (~== govtHospitalTag) $ tags
      hospitalTagText = filter isTagText hospitals

      refinedTags = filterUnwanted hospitalTagText

      govtTags = map (removeQuotes . lstrip . BC.unpack .  fromTagText) $ govtHospitals refinedTags
      privateTags = map (removeQuotes . lstrip . BC.unpack . fromTagText) $ privateHospitals refinedTags

      allHospitals = govttoHospital govtTags ++ privatetoHospitals privateTags :: [Hospital]
      
  putStrLn (show $  allHospitals)  -- govttoHospital govtTags) -- allHospitals) -- $ privatetoHospitals privateTags)
