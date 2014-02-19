{-# LANGUAGE OverloadedStrings #-}

--- Example of Nested JSON
import Data.Aeson
import Data.Text (Text)
import Control.Applicative
import Control.Monad
import qualified Data.ByteString.Lazy.Char8 as BL
import qualified Data.Vector as V

--- Example of Array within an object

--- The best way to tackle these problem is by adapting the ADT to the
  --- structure of the JSON.

--- See this thread: http://stackoverflow.com/questions/16547783/parse-array-in-nested-json-with-aeson

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
