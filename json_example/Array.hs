{-# LANGUAGE OverloadedStrings #-}

--- Example of Nested JSON
import Data.Aeson
import Data.Text (Text)
import Control.Applicative
import Control.Monad
import qualified Data.ByteString.Lazy.Char8 as BL
import qualified Data.Vector as V

--- Example of Array within an object

test = BL.pack "{ \"persons\": [{ \"name\":\"Joe\",\"age\":12}]}"

data Person = Person
     { name :: Text
     , age  :: Int
     } deriving Show

newtype Persons = Persons [Person] deriving (Show)

instance FromJSON Persons where
  parseJSON (Object v) = Persons <$>
                         v .: "persons"

instance FromJSON Person where
     parseJSON (Object v) = Person <$>
                            v .: "name" <*>
                            v .: "age"
     -- A non-Object value is of the wrong type, so fail.
     parseJSON _          = mzero
