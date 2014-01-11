{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE FlexibleInstances #-}

import Data.Char (isHexDigit, digitToInt)

class Error a where
    noMsg :: a
    strMsg :: String -> a

class (Monad m) => MonadError e m | m -> e where
    throwError :: e -> m a
    catchError :: m a -> (e -> m a) -> m a

instance Error e => MonadError e (Either e) where
    throwError = Left 
    (Left e) `catchError` handler = handler e 
    a        `catchError` _       = a

--- Example

data ParseError = Err {location :: Int, reason :: String}

instance Error ParseError where
  noMsg = Err 0 "ParseError"
  strMsg s = Err 0 s

type ParseMonad = Either ParseError

parseHexDigit :: Char -> Int -> ParseMonad Integer
parseHexDigit c idx = if isHexDigit c
                      then return (toInteger (digitToInt c))
                      else throwError (Err idx ("Invalid character '" ++ [c] ++ "'"))

parseHex :: String -> ParseMonad Integer
parseHex s = parseHex' s 0 1
  where parseHex' [] val _ = return val
        parseHex' (c:cs) val idx = do d <- parseHexDigit c idx
                                      parseHex' cs (val * 16 + d) (idx + 1)

toString :: Integer -> ParseMonad String
toString n = return $ show n

convert :: String -> String
convert s = let (Right str) = do {n <- parseHex s; toString n} `catchError` printError
            in str
  where printError e = return $ "At index" ++ (show (location e)) ++ ":" ++ (reason e)
