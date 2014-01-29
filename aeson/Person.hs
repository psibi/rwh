{-# LANGUAGE OverloadedStrings #-}

import Data.Aeson
import Control.Applicative
import Control.Monad

data Person = Person
     { name :: String
     , age  :: Age
     } deriving Show

data Age = Five | Six | Other deriving (Show)

instance ToJSON Age where
  toJSON (Five) = object [("Age",Number 5)]
  toJSON (Six) = object [("Age",Number 6)]
  toJSON (Other) = object [("Age",Number 100)]

instance ToJSON Person where
   toJSON (Person name age) = object ["Name" .= name, "Age" .= age]
