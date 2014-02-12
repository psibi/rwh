{-# LANGUAGE OverloadedStrings #-}

import qualified Data.ByteString as B
import qualified Data.ByteString.Char8 as BC
import qualified Data.ByteString.Lazy.Char8 as BL
import Text.HTML.TagSoup
import Data.String.Utils (strip)
import Data.Aeson

byteNode = BC.pack "node"
byteTag = BC.pack "tag"
hospitalAttribute = [(BC.pack "k",BC.pack "amenity"),
                     (BC.pack "v",BC.pack "hospital")]

extractHospitalNode :: [Tag BC.ByteString] -> [Tag BC.ByteString]
extractHospitalNode [] = []
extractHospitalNode (a:b:c:d:e:f:xs)
  | a ~== TagOpen byteNode []
    && b ~== TagOpen byteTag hospitalAttribute
    && c ~== TagClose byteTag
    && d ~== TagOpen byteTag []
    && e ~== TagClose byteTag
    && f ~== TagClose byteNode = a:b:c:d:e:f: extractHospitalNode xs
extractHospitalNode (x:xs) = extractHospitalNode xs

removeUnwanted tags = filter remove tags
  where remove tag = not $ isTagText tag

data Hospital = Hospital {
  hospitalOSMid :: !Integer,
  hospitalLatitude :: !Double,
  hospitalLongitude :: !Double,
  hospitalName :: !String
  } deriving (Show)

instance ToJSON Hospital where
  toJSON (Hospital osmid lat lon name) = object [ "osmid" .= osmid
                                                , "latitude " .= lat
                                                , "longitude" .= lon
                                                , "name" .= name
                                                ]

toHospital :: [Tag BC.ByteString] -> [Hospital]
toHospital [] = []
toHospital (a:b:c:d:e:f:xs) = (Hospital osmId lat lon hname): toHospital xs
  where osmId = read $ BC.unpack $ fromAttrib (BC.pack "id") a
        lat = read $ BC.unpack $ fromAttrib (BC.pack "lat") a
        lon = read $ BC.unpack $ fromAttrib (BC.pack "lon") a 
        hname = BC.unpack $ fromAttrib (BC.pack "v") d

main :: IO ()
main = do
  content <- B.readFile "/home/sibi/github/data/chennai.osm" 
  let tags = removeUnwanted $ parseTags content --testTag -- content
      hospitals = toHospital $ extractHospitalNode tags
  BL.writeFile "osmHospitals.json" (encode hospitals)
 
