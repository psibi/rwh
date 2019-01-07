#!/usr/bin/env stack
-- stack script --resolver lts-13.1

{-#LANGUAGE OverloadedStrings#-}
{-#LANGUAGE ScopedTypeVariables#-}

import Data.Text
import Data.Aeson.Types
import Data.Yaml
import Data.Monoid


data Config = Config {
      cfPackages :: [FilePath],
      cfNestedPaths :: [FilePath],
      dockerEnable :: Bool,
      cfContainers :: Array
} deriving Show

packages :: Value
packages = object [ ("packages", array [String "path1", String "path2"]), docker, nested, image]

docker :: Pair
docker = ("docker", object [("enable", Bool True), ("repo", String "fpco/stack-full")])

nested :: Pair
nested = ("nested", object [("paths", array [String "fpco/stack-base", String "fpco-stack-test"])])

image :: Pair
image = ("image", object [("containers", array [ object [ ("base", String "fpco/stack-base"), ("name", String "fpco/stack-test")]])])

main :: IO ()
main = do
  encodeFileWith defaultEncodeOptions "/home/sibi/github/rwh/yaml/write.yaml" packages
