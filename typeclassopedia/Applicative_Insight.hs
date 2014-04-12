-- http://comonad.com/reader/2012/abstracting-with-applicatives/

import Control.Applicative hiding (Const)
import Data.Monoid hiding (Sum, Product)
import Control.Monad.Identity

instance (Show a) =>  Show (Identity a) where
  show (Identity x) = "(Identity " ++ show x ++ ")"

data Const mo a = Const mo deriving (Show)

instance Functor (Const mo) where
  fmap _ (Const mo) = Const mo

instance Monoid mo => Applicative (Const mo) where
  pure _ = Const mempty
  (Const f) <*> (Const g) =  Const (f <> g)

newtype Compose f g a = Compose (f (g a)) deriving Show

instance (Functor f, Functor g) => Functor (Compose f g) where
    fmap f (Compose x) = Compose $ (fmap . fmap) f x


-- fmap.fmap :: (a -> b) -> f (g a) ->  f (g b)
-- let a = Compose (Just (Just 3))

-- f :: (a -> b)
-- x :: f (g a)

-- So voila everything typechecks!
