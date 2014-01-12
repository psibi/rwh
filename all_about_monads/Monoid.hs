class Monoid a where
  mempty :: a
  mappend :: a -> a -> a
  mconcat :: [a] -> a
  mconcat = foldr mappend mempty

-- <> is alias for mappend

instance Monoid [a] where
  mempty = []
  mappend = (++)
