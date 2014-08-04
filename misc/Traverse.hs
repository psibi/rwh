import Control.Applicative
import Data.Foldable

class (Functor t, Foldable t) => Traversable t where
    traverse  :: Applicative f => (a -> f b) -> t a -> f (t b)
    sequenceA :: Applicative f => t (f a) -> f (t a)

instance Traversable [] where
  traverse f [] = pure []
  traverse f (x:xs) = (:) <$> (f x) <*> traverse f xs
