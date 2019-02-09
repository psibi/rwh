{-# LANGUAGE TemplateHaskell #-}

module Test where

import Lib

$(genSampleInt)

$(genSampleInt2)

$(genSampleInt3 8)

$(genSampleInt4 2)

$(genSampleInt5 (\x -> 99) 4)
