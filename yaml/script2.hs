#!/usr/bin/env stack
-- stack script --resolver lts-12.7

{-#LANGUAGE OverloadedStrings#-}
{-#LANGUAGE ScopedTypeVariables#-}

import Data.Text
import Data.Yaml
import Data.List.NonEmpty
import Data.Vector (Vector)
import qualified Data.Vector as Vector
import Data.Aeson
import Data.Semigroup ((<>))
import qualified Data.HashMap.Strict as HM
import Debug.Trace
import Data.Foldable (fold)

data Item = Item { itemKey :: String, itemNumber :: Int } deriving (Show, Eq, Ord)

-- sample:
--  - kool:
--    - a: 1
--      b: hello

-- Object (fromList [("sample",Array [Object (fromList [("kool",Array [Object (fromList [("a",Number 1.0),("b",String "hello")])])])])])

instance FromJSON Item where
    parseJSON = parseItem

parseItem :: Value -> Parser Item
parseItem val = withObject "item"
                (\obj -> do
                   num <- obj .: "a"
                   str <- obj .: "b"
                   return $ Item str num
                   ) val

isKoolObject :: Value -> Bool
isKoolObject (Object xs) = HM.member "kool" xs
isKoolObject _ = False

getObjectFromArray :: Value -> Value
getObjectFromArray (Array xs) = Array (Vector.filter isKoolObject xs)
getObjectFromArray _ = error "sorry"

parseYamlFile :: Value -> Parser (NonEmpty Item)
parseYamlFile val = withObject "sample.stack"
                    (\obj -> do
                       sample <- obj .: "sample"
                       withArray "sample array" (\(vector') -> do
                                                   let (Array vector) = getObjectFromArray (Array vector')
                                                       j :: Vector (Parser (NonEmpty Item)) = Vector.map (\((Object v)) -> do
                                                                                                 v' <- v .: "kool"
                                                                                                 v'' :: NonEmpty Item <- parseJSON v'
                                                                                                 pure v''
                                                                                                 ) (vector :: Vector Value)
                                                       j'' = sequence j
                                                   j''' <- j''
                                                   let j'''' = Vector.foldr1 (<>) j'''
                                                   pure j''''
                                                   ) sample
                       ) val

main :: IO ()
main = do
  xs <- decodeFileEither "/home/sibi/github/rwh/yaml/test2.yaml"
  case xs of
    Left _ -> error "decode issue"
    Right (v :: Value) -> do
            let pkg = parseEither parseYamlFile v
            case pkg of
              Left _ -> error $ "decode issue 2" <> show v
              Right pkg' -> print pkg'
