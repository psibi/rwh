class (Monad m) => MonadError e m | m -> e where
    throwError :: e -> m a
    catchError :: m a -> (e -> m a) -> m a

instance MonadError (Either e) where
    throwError = Left
    (Left e) `catchError` handler = handler e
    a `catchError` _ = a
