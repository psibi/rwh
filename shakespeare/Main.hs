module Main where

import TestHamlet
import qualified Data.Text.Lazy.IO as TLIO
import Text.Blaze.Html.Renderer.Text (renderHtml)

main :: IO ()
main = TLIO.putStrLn (renderHtml $ template render)
