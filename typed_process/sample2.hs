#!/usr/bin/env stack
-- stack --resolver lts-9.9 --install-ghc runghc --package typed-process
{-# LANGUAGE OverloadedStrings #-}
import System.Process.Typed

main :: IO ()
main = do
    -- Command and arguments
    runProcess (proc "cat" ["/etc/hosts"]) >>= print

    -- Shell
    runProcess (shell "cat /etc/hosts >&2 && false") >>= print
