module Main where

{-# LANGUAGE OverloadedStrings #-}
import System.Process.Typed

main :: IO ()
main = do
    -- Command and arguments
    runProcess (proc "cat" ["/etc/hosts"]) >>= print

    -- Shell
    runProcess (shell "cat /etc/hosts >&2 && false") >>= print
