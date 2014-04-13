{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

-- https://www.fpcomplete.com/user/tel/basic-lensing
-- Not exactly follows the article, slightly different.

import Control.Lens

data Arc = Arc { _degree :: Int, _minute :: Int, _second :: Int }
data Location = Location { _latitude :: Arc, _longitude :: Arc}

makeLenses ''Location

getLatitude :: Location -> Arc
getLatitude loc = view latitude loc

setLatitude :: Arc -> Location -> Location
setLatitude arc loc = set latitude arc loc

getLatitudeR :: Location -> Arc
getLatitudeR (Location { _latitude = lat }) = lat

setLatitudeR :: Arc -> Location -> Location
setLatitudeR ac loc = loc { _latitude = ac }

modifyLatitude :: (Arc -> Arc) -> (Location -> Location)
modifyLatitude f = latitude `over` f

modifyLatitude2 :: (Arc -> Arc) -> Location -> Location
modifyLatitude2 f lat = setLatitude (f $ getLatitude lat) lat

makeLenses ''Arc

getDegreeofLat :: Location -> Int
getDegreeofLat = view degree . view latitude

setDegreeofLat :: Int -> Location -> Location
setDegreeofLat = over latitude . set degree

degreeofLat'Manually :: Lens' Location Int
degreeofLat'Manually = lens getDegreeofLat (flip setDegreeofLat)

-- degreeofLat = latitude . degree
