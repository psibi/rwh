{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE FlexibleInstances #-}

-- Demonstrates functional dependency

class Foo a b c | a b -> c where
  foo :: a -> b -> c

instance Foo Int Int Int where
  foo a b = a + b  

-- ghci > foo 4 4

instance Foo Float Float Float where
  foo a b = a + b

instance Foo (Maybe Int) (Maybe Int) Int where
  foo a b = case (a, b) of
              (Just x, Nothing) -> x
              (Nothing, Just x) -> x
              (Just x, Just y) -> x + y
              _ -> 0

-- ghci > foo (Just 3 :: Maybe Int) (Just 3 :: Maybe Int)
-- 6
