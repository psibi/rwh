{-# LANGUAGE OverloadedStrings #-}

--- Example of Nested JSON

import Data.Aeson
import Data.Text (Text)
import Control.Applicative
import Control.Monad
import qualified Data.ByteString.Lazy.Char8 as BL

test = BL.pack "{ \"persons\": { \"name\":\"Joe\",\"age\":12}}"

data Person = Person
     { name :: Text
     , age  :: Int
     } deriving Show

instance FromJSON Person where
     parseJSON (Object v) = Person <$>
                            ((v .: "persons") >>= (.: "name")) <*>
                            ((v .: "persons") >>= (.: "age"))
     -- A non-Object value is of the wrong type, so fail.
     parseJSON _          = mzero

     
