#!/usr/bin/env stack
-- stack script --resolver lts-12.7

{-#LANGUAGE OverloadedStrings#-}
{-#LANGUAGE ScopedTypeVariables#-}

import Data.Text
import Data.Yaml


data Config = Config {
      cfPackages :: [FilePath],
      cfNestedPaths :: [FilePath],
      dockerEnable :: Bool,
      cfContainers :: Array
} deriving Show

parseYamlFile :: Value -> Parser Config
parseYamlFile val = withObject "sample.stack yaml file"
                    (\obj -> do
                       packages <- obj .:? "packages" .!= []
                       imgs <-  obj .: "nested"
                       img <- imgs .: "paths"
                       docker <- obj .: "docker"
                       dockerEnab <- docker .: "enable"
                       image <- obj .: "image"
                       (containers :: Array) <- image .: "containers"
                       return $ Config {
                                    cfPackages = packages,
                                    cfNestedPaths = img,
                                    dockerEnable = dockerEnab,
                                    cfContainers = containers
                                  }
                    ) val

main :: IO ()
main = do
  xs <- decodeFileEither "/home/sibi/github/rwh/yaml/test.yaml"
  case xs of
    Left _ -> error "decode issue"
    Right (v :: Value) -> do
            let pkg = parseEither parseYamlFile v
            case pkg of
              Left _ -> error "decode issue 2"
              Right pkg' -> print pkg'
