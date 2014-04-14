{-# LANGUAGE TemplateHaskell #-}
-- https://www.fpcomplete.com/user/tel/a-little-lens-starter-tutorial

import Control.Lens

type Degrees = Double
type Latitude = Degrees
type Longitude = Degrees

data Meetup = Meetup { _name :: String, _location :: (Latitude, Longitude) }
makeLenses ''Meetup

meetupLat :: Lens' Meetup Latitude
meetupLat = location._1


