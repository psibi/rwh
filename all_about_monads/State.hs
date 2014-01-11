{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE FunctionalDependencies #-}

newtype State s a = State { runState :: (s -> (a, s)) }

instance Monad (State s) where
  return a = State $ \s -> (a, s)
  (State x) >>= f = State $ \s -> let (v, s') = x s in runState (f v) s'

class MonadState m s | m -> s where
  get :: m s
  put :: s -> m ()

instance MonadState (State s) s where
  get = State $ \s -> (s, s)
  put s = State $ \_ -> ((), s)

--- Example

data State1 = State1 {
  someInt :: Int,
  someString :: String
              } deriving (Show)

type TestState = State State1 Int

testFun :: TestState -> State1 -> Int
testFun st s = fst $ runState st s
