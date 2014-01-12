{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE FunctionalDependencies #-}

import Data.Monoid

newtype Writer w a = Writer { runWriter :: (a,w) }

instance (Monoid w) => Monad (Writer w) where
  return a = Writer (a, mempty)
  (Writer (a,w)) >>= f = let (a',w') = runWriter (f a)
                         in Writer (a', w `mappend` w')

class (Monoid w, Monad m) => MonadWriter w m | m -> w where
  pass :: m (a,w -> w) -> m a
  listen :: m a -> m (a,w)
  tell :: w -> m ()

instance (Monoid w) => MonadWriter w (Writer w) where
  pass (Writer ((a,f),w)) = Writer (a, f w)
  listen (Writer (a,w)) = Writer ((a,w), w)
  tell s = Writer ((), s)

listens :: (MonadWriter w m) => (w -> b) -> m a -> m (a,b)
listens f m = do (a,w) <- listen m; return (a,f w)

censor :: (MonadWriter w m) => (w -> w) -> m a -> m a 
censor f m = pass $ do a <- m; return (a,f)
