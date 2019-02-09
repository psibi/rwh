{-# LANGUAGE TemplateHaskell #-}

module Lib where

import Language.Haskell.TH

someFunc :: IO ()
someFunc = putStrLn "someFunc"

-- The aim is to generate the following functions:
-- sampleInt :: Int
-- sampleInt = 32
-- Do stack ghci:
-- λ> import Language.Haskell.TH
-- λ> :set -XTemplateHaskell
-- λ> runQ [d| sampleInt = 3 |]
-- [ValD (VarP sampleInt_0) (NormalB (LitE (IntegerL 3))) []]
-- λ> runQ [d| sampleInt :: Int; sampleInt = 3 |]
-- [SigD sampleInt_1 (ConT GHC.Types.Int),ValD (VarP sampleInt_1) (NormalB (LitE (IntegerL 3))) []]
-- So now you need to write a function which produces that definition.
genSampleInt :: Q [Dec]
genSampleInt = do
  let si = mkName "sampleInt"
  return $
    [SigD si (ConT ''Int), ValD (VarP si) (NormalB (LitE (IntegerL 3))) []]
