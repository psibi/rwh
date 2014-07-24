import Control.Applicative

data User = User deriving Show

findById :: Int -> IO (Maybe User)
findById 1 = return (Just User)
findById _ = return Nothing

findUsers :: Int -> Int -> IO (Maybe (User, User))
findUsers x y = do
  muser1 <- findById x

  case muser1 of
    Nothing -> return Nothing
    Just user1 -> do
      muser2 <- findById y

      case muser2 of
        Nothing -> return Nothing
        Just user2 -> do
          return (Just (user1, user2))

newtype MaybeIO a = MaybeIO { runMaybeIO :: IO (Maybe a) }

instance Functor MaybeIO where
  fmap f (MaybeIO x) =  MaybeIO $ (fmap.fmap) f x

instance Applicative MaybeIO where
  (MaybeIO f) <*> (MaybeIO x) = MaybeIO $ liftA2 (<*>) f x
  pure = MaybeIO . pure . pure

instance Monad MaybeIO where
  return = MaybeIO . pure . pure
  (MaybeIO f) >>= a = MaybeIO $ f >>= \x -> case x of
    Nothing -> return Nothing
    Just f' -> runMaybeIO $ a f'

smartFindUsers :: Int -> Int -> MaybeIO (User, User)
smartFindUsers x y = do
  user1 <- MaybeIO $ findById x
  user2 <- MaybeIO $ findById y
  return (user1, user2)

newtype MaybeT m a = MaybeT { runMaybeT :: m (Maybe a) }

instance Monad m => Monad (MaybeT m) where
  return = MaybeT . return . return 
  (MaybeT x) >>= f = MaybeT $ x >>= \x' -> case x' of
    Nothing -> return Nothing
    Just x'' -> runMaybeT $ f x''
