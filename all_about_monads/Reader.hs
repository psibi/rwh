{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE FunctionalDependencies #-}

import Data.Maybe (fromJust)
import qualified Data.Map as Map

newtype Reader e a = Reader { runReader :: (e -> a) }

instance Monad (Reader e) where
  return a = Reader (\e -> a)
  (Reader r) >>= f = Reader $ \e -> runReader (f (r e)) e

class (Monad m) => MonadReader e m | m -> e where
  ask :: m e
  local :: (e -> e) -> m a -> m a

instance MonadReader e (Reader e) where
  ask = Reader id
  local f c = Reader $ \e -> runReader c (f e)

asks :: (MonadReader e m) => (e -> a) -> m a
asks sel =   do
  r <- ask
  return (sel r)


-- Reader Example
 -- (http://www.haskell.org/ghc/docs/6.10.2/html/libraries/mtl/Control-Monad-Reader.html)

type Bindings = Map.Map String Int

lookupVar :: String -> Bindings -> Int
lookupVar name bindings = fromJust $ Map.lookup name bindings

calcIsCountCorrect :: Reader Bindings Bool
calcIsCountCorrect = do
  count <- asks $ lookupVar "count"
  bindings <- ask
  return (count == (Map.size bindings))

isCountCorrect :: Bindings -> Bool
isCountCorrect bindings = runReader calcIsCountCorrect bindings

sampleBindings = Map.fromList [("count",3), ("1",1), ("b",2)]  
  


