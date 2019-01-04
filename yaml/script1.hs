#!/usr/bin/env stack
-- stack script --resolver lts-12.7

{-#LANGUAGE OverloadedStrings#-}
{-#LANGUAGE ScopedTypeVariables#-}

import Data.Text
import Data.Yaml


data Packages = Packages [FilePath] deriving Show

parseYamlFile :: Value -> Parser Packages
parseYamlFile val = withObject "sample.stack yaml file"
                    (\obj -> do
                       packages <- obj .:? "packages" .!= []
                       return $ Packages packages
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
