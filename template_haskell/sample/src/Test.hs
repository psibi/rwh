{-# LANGUAGE TemplateHaskell #-}

module Test where

import Lib

$(genSampleInt)
