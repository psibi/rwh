{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE DeriveLift #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Str where

import Language.Haskell.TH
import Language.Haskell.TH.Quote
import Language.Haskell.TH.Syntax
import Data.Time.Format
import Data.Time

str :: QuasiQuoter
str =
  QuasiQuoter
  { quoteExp = stringE
  }

deriving instance Lift Day

instance Lift DiffTime where
  lift x = return $ LitE (IntegerL $ diffTimeToPicoseconds x)

deriving instance Lift UTCTime

time :: QuasiQuoter
time =
  QuasiQuoter
  { quoteExp =
    \str ->
       let (item :: Maybe UTCTime) = parseTimeM True defaultTimeLocale "%Y" str
       in [|item|]
  }
-- instance Lift UTCTime
