{-# LANGUAGE OverloadedStrings #-} -- we're using Text below
{-# LANGUAGE TemplateHaskell #-}

module TestHamlet where

import Text.Hamlet (Html, hamletFileReload)
import Data.Text (Text)
import Text.Blaze.Html.Renderer.Text (renderHtml)
import qualified Data.Text.Lazy.IO as TLIO

data MyRoute = Home

render :: MyRoute -> [(Text, Text)] -> Text
render Home _ = "/home"

template = $(hamletFileReload "template.hamlet")


