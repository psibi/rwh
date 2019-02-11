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

-- That's all it takes. See the 'Test.hs' module in which the code is generated.
-- Let's test that in ghci:
-- λ> import Test
-- λ> :t sampleInt
-- sampleInt :: Int
-- λ> sampleInt
-- 3
-- Another way to do the same stuff
genSampleInt2 :: Q [Dec]
genSampleInt2 =
  [d|

  sampleInt2 :: Int
  sampleInt2 = 4 |]

-- Can we pass parameter to the functions ? Let's check that out
genSampleInt3 :: Int -> Q [Dec]
genSampleInt3 x =
  [d|

  sampleInt3 :: Int
  sampleInt3 = x |]

-- And that works fine. Ok, now let's move to more complex stuff. Can we pass it a function?
-- Let's define some function
dummyFunction :: Int -> Int
dummyFunction x = x * 100

-- Now let's try to use that dummyFunction in the generator function:
genSampleInt4 :: Int -> Q [Dec]
genSampleInt4 x =
  [d|

  sampleInt4 :: Int
  sampleInt4 = if (x > 3) then x * 5 else dummyFunction x |]

-- That also works. Cool!
-- Now let's try to see if you can pass a combinator to the generator function.
-- This code doesn't work:
-- genSampleInt5 :: (Int -> Int) -> Int -> Q [Dec]
-- genSampleInt5 comb x =
--   [d|
--   sampleInt5 :: Int
--   sampleInt5 = comb x |]
genSampleInt5 :: (Int -> Int) -> Int -> Q [Dec]
genSampleInt5 comb x =
  let f = comb x
   in [d|

  sampleInt5 :: Int
  sampleInt5 = f |]

-- Can the function be dynamically generated in genSampleInt5 ? Let's try that out
genSampleInt6 :: (Int -> Int) -> Int -> Q [Dec]
genSampleInt6 comb x =
  let f = comb x
      funName = mkName "sampleInt6"
   in [d|

  funName :: Int
  funName = f |]
-- The above code will not work. It will generate a function named `funName`
