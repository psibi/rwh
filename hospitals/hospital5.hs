{-# LANGUAGE OverloadedStrings #-}

import qualified Data.ByteString as B
import qualified Data.ByteString.Char8 as BC
import qualified Data.ByteString.Lazy.Char8 as BL
import Text.HTML.TagSoup
import Data.Aeson
import qualified Data.Conduit.List as CL
import Data.Conduit
import Data.Conduit.Binary (sinkFile)
import Control.Monad.IO.Class

byteNode = BC.pack "node"
byteTag = BC.pack "tag"
hospitalAttribute = [(BC.pack "k",BC.pack "amenity"),
                     (BC.pack "v",BC.pack "hospital")]

extractCHospitalNode :: Conduit (Tag BC.ByteString) (ResourceT IO) (Tag BC.ByteString)
extractCHospitalNode = do
  a <- await
  b <- await
  c <- await
  d <- await
  e <- await
  f <- await
  case (a,b,c,d,e,f) of
    (Just a,Just b,Just c,Just d,Just e,Just f) -> do
      if (a ~== TagOpen byteNode [] &&
          b ~== TagOpen byteTag hospitalAttribute &&
          c ~== TagClose byteTag &&
          d ~== TagOpen byteTag [] &&
          e ~== TagClose byteTag &&
          f ~== TagClose byteNode)
        then do yield a
                yield b
                yield c
                yield d
                yield e
                yield f
                extractCHospitalNode
        else extractCHospitalNode
    _ -> return ()
        
removeCUnwanted :: Conduit (Tag str) (ResourceT IO) (Tag str)
removeCUnwanted = CL.filter remove 
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

toCHospital :: Conduit (Tag BC.ByteString) (ResourceT IO) BC.ByteString
toCHospital = do
  a <- await
  b <- await
  c <- await
  d <- await
  e <- await
  f <- await
  case (a,b,c,d,e,f) of
    (Just a, Just b, Just c, Just d, Just e, Just f) -> do
      let osmId = read $ BC.unpack $ fromAttrib (BC.pack "id") a
          lat = read $ BC.unpack $ fromAttrib (BC.pack "lat") a
          lon = read $ BC.unpack $ fromAttrib (BC.pack "lon") a 
          hname = BC.unpack $ fromAttrib (BC.pack "v") d
      yield $ toStrict1 $ encode (Hospital osmId lat lon hname)
      toCHospital
    _ -> return ()
      
toStrict1 :: BL.ByteString -> BC.ByteString
toStrict1 = BC.concat . BL.toChunks

source :: Source (ResourceT IO) (Tag BC.ByteString)
source = do
  content <- liftIO $ B.readFile "/home/sibi/github/data/test.osm" 
  CL.sourceList $ parseTags content

main :: IO ()
main = runResourceT $
        source $= (removeCUnwanted =$= extractCHospitalNode =$= toCHospital) $$ sinkFile "osmHospitals.json"

