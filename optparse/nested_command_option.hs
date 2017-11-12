{-#LANGUAGE ScopedTypeVariables#-}

module Main where

import Data.Semigroup ((<>))
import Options.Applicative

data Opts = Opts
    { optGlobalFlag :: !Bool
    , optCommand :: !Command
    }

data CreateOpts = CreateOpts {
      coptsFlag :: Bool,
      coptsHelpFlag :: Bool,
      coptsCommand :: String
} deriving (Show, Eq, Ord)

data Command
    = Create CreateOpts
    | Delete

main :: IO ()
main = do
    (opts :: Opts) <- execParser optsParser
    case optCommand opts of
        Create name -> putStrLn ("Created the thing named " ++ (show name))
        Delete -> putStrLn "Deleted the thing!"
    putStrLn ("global flag: " ++ show (optGlobalFlag opts))
  where
    optsParser :: ParserInfo Opts
    optsParser =
        info
            (helper <*> versionOption <*> programOptions)
            (fullDesc <> progDesc "optparse subcommands example" <>
             header
                 "optparse-sub-example - a small example program for optparse-applicative with subcommands")
    versionOption :: Parser (a -> a)
    versionOption = infoOption "0.0" (long "version" <> help "Show version")
    programOptions :: Parser Opts
    programOptions =
        Opts <$> switch (long "global-flag" <> help "Set a global flag") <*>
        hsubparser (createCommand <> deleteCommand)
    createCommand :: Mod CommandFields Command
    createCommand =
        command
            "create"
            (info copt (progDesc "Create a thing"))
    deleteCommand :: Mod CommandFields Command
    deleteCommand =
        command
            "delete"
            (info (pure Delete) (progDesc "Delete the thing"))
    test :: Parser CreateOpts
    test = undefined
    createOptions :: Parser CreateOpts
    createOptions = CreateOpts <$> switch (long "some-flag" <> help "Set the flag") <*> switch (long "ome-flag" <> help "Set the flag") <*> strArgument (metavar "NAME" <> help "Name of the thing to create")
    copt :: Parser Command
    copt = fmap (Create) createOptions
    -- createOptions =
    --     Create <$>
    --     strArgument (metavar "NAME" <> help "Name of the thing to create")

