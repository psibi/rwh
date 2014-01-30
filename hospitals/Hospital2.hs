{-# LANGUAGE OverloadedStrings #-}

import qualified Data.ByteString as B
import qualified Data.ByteString.Lazy.Char8 as BL
import qualified Data.ByteString.Char8 as BC
import Text.HTML.TagSoup
import Data.String.Utils (lstrip, split)
import Data.List (isPrefixOf)
import System.IO
import Data.Aeson
import EndPoint hiding (main)
import Data.Definitions
import Network.HTTP.Conduit
import Numeric (showFloat)

govtHospitalTag = TagText "GOVERNMENT HOSPITALS - CHENNAI" :: Tag String
privateHospitalTag = TagText "PRIVATE HOSPITALS" :: Tag String
privateHospEnd = TagText "Last Updated on 11/2/2011" :: Tag String

data HospitalType = Government | Private
                  deriving (Show)

data Hospital = Hospital {
  hospitalName :: !String,
  hospitalAddress :: !String,
  hospitalType :: !HospitalType,
  hospitalPhone :: !(Maybe String),
  hospitalLocation :: !(Maybe String) -- Lat/Long
  } deriving (Show)

instance ToJSON HospitalType where
  toJSON (Government) = String "Government"
  toJSON (Private) = String "Private"

instance ToJSON Hospital where
  toJSON (Hospital hospitalName hospitalAddress hospitalType hospitalPhone hLoc) =
    object [ "hospitalName" .= hospitalName
           , "hospitalAddress" .= hospitalAddress
           , "hospitalType" .= hospitalType
           , "hospitalPhone" .= hospitalPhone
           , "hospitalLocation" .= hLoc]

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
                               then (Hospital x1 x2 Government (Just x3) Nothing):govttoHospital x4
                               else govttoHospital $ (x1 ++ x2):x3:x4

privatetoHospitals :: [String] -> [Hospital]
privatetoHospitals [] = []
privatetoHospitals (x1:x2:x3) = (Hospital x1 x2 Private Nothing Nothing):
                                privatetoHospitals x3

sanitizeAddress :: [Hospital] -> [Hospital]
sanitizeAddress xs = map cleanAddress xs
  where cleanAddress hosp = hosp { hospitalAddress = (head $ split "Chenn" (hospitalAddress hosp))
                                 ++ "Chennai"}

removeQuotes :: String -> String
removeQuotes str = filter (\ch -> ch /= '\"' &&
                                  ch /= '\\' ) str

writeToFile :: FilePath -> [Hospital] -> IO ()
writeToFile fname hospitals = BL.writeFile fname (encode hospitals)

feedLatLon :: Hospital -> IO Hospital
feedLatLon hosp = do
  geoData <- latLon req hproxy
  case geoData of
    Left _ -> return hosp
    Right [] -> return hosp
    Right (x:xs) -> return $ hosp {hospitalLocation = Just $ latLontoString x}
  where req = NominatimRequest Nothing (hospitalAddress hosp)
        hproxy = Nothing -- Just $ Proxy "127.0.0.1" 3129

        latLontoString resp = (showFloat (longitude resp) ",") ++ 
                              (showFloat (latitude resp) "")

main :: IO ()
main = do
  content <- B.readFile "hospitals-in-chennai.html"
  let tags = parseTags content
      hospitals = fst . break (~== privateHospEnd) $ snd . break (~== govtHospitalTag) $ tags
      hospitalTagText = filter isTagText hospitals

      refinedTags = filterUnwanted hospitalTagText

      govtTags = map (removeQuotes . lstrip . BC.unpack .  fromTagText) $ govtHospitals refinedTags
      privateTags = map (removeQuotes . lstrip . BC.unpack . fromTagText) $ privateHospitals refinedTags

      allHospitals = sanitizeAddress $ govttoHospital govtTags ++ privatetoHospitals privateTags :: [Hospital]

  hospWithLocations <- mapM feedLatLon allHospitals
  writeToFile "hospitals.json" hospWithLocations
