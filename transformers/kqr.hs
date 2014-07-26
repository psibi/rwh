{-# LANGUAGE OverloadedStrings #-}

import           Control.Applicative
import           Data.Map as Map
import           Data.Text
import qualified Data.Text.IO as T

data LoginError = InvalidEmail
                | NoSuchUser
                | WrongPassword
                deriving Show

getDomain :: Text -> Either LoginError Text
getDomain email = case splitOn "@" email of
  [name, domain] -> Right domain
  _ -> Left InvalidEmail

printResult' :: Either LoginError Text -> IO ()
printResult' domain = case domain of
  Right text -> T.putStrLn (append "Domain: " text)
  Left InvalidEmail -> T.putStrLn "ERROR: Invalid domain"

printResult :: Either LoginError Text -> IO ()
printResult = T.putStrLn . either
              (const "Error: Invalid domain")
              (append "Domain: ")

getToken :: IO (Either LoginError Text)
getToken = do
  T.putStrLn "Enter email address"
  email <- T.getLine
  return $ getDomain email

users :: Map Text Text
users = Map.fromList [("example.com", "qwerty123"), ("localhost", "password")]

userLogin :: IO (Either LoginError Text)
userLogin = do
  token <- getToken

  case token of
    Right domain ->
      case Map.lookup domain users of
        Just userpw -> do
          T.putStrLn "enter password"
          password <- T.getLine

          if userpw == password
            then return token
            else return (Left WrongPassword)

        Nothing -> return $ Left NoSuchUser
    left -> return left

data EitherIO e a = EitherIO { runEitherIO :: IO (Either e a) }

instance Functor (EitherIO e) where
  fmap f (EitherIO x) = EitherIO $ (fmap.fmap) f x

instance Applicative (EitherIO e) where
  pure = EitherIO . pure . pure
  (EitherIO f) <*> (EitherIO x) = EitherIO $ liftA2 (<*>) f x

instance Monad (EitherIO e) where
  return = EitherIO . return . return
  (EitherIO x) >>= f = EitherIO $ x >>= either (return . Left) (runEitherIO . f)

