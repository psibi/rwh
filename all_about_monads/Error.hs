{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE FlexibleInstances #-}

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

data ParseError = ParseError {location :: Int, reason :: String}
