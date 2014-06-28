import Control.Monad (when)
import Control.Monad.Trans.Cont

add :: Int -> Int -> Int
add x y = x + y

square :: Int -> Int
square x = x * x

pythagoras :: Int -> Int -> Int
pythagoras x y = add (square x) (square y)

add_cont :: Int -> Int -> Cont r Int
add_cont x y = return (add x y)

square_cont :: Int -> Cont r Int
square_cont x = return (square x)

pythagoras_cont :: Int -> Int -> Cont r Int
pythagoras_cont x y = do
  a <- square_cont x
  b <- square_cont y
  add_cont a b

squarec :: Int -> Cont r Int
squarec x = return (x ^ 2)

squareCCC :: Int -> Cont r Int
squareCCC x = callCC $ \k -> k (x ^ 2)

foo :: Int -> Cont r String
foo x = callCC $ \k -> do
  let y = x ^ 3 + 3
  when (y > 20) $ k "over twenty"
  return (show $ y - 4)

bar :: Char -> String -> Cont r Int
bar c s = do
  msg <- callCC $ \k -> do
    let s' = c : s
    when (s' == "hello") (k "hi dude, hello")
    let s'' = show s'
    return $ "They appear to be saying" ++ s''
  return $ length msg

-- callCC :: ((a -> Cont r b) -> Cont r a) -> Cont r a

-- k :: a -> Cont r b
quux :: Cont r Int
quux = callCC $ \k -> do
  let n = 4
  k n
  return 25

Clarification on type signature of callCC

I have been going through CPS section in [Wikibooks](http://en.wikibooks.org/wiki/Haskell/Continuation_passing_style)
and have come across a sample piece of code:

quux :: Cont r Int
quux = callCC $ \k -> do
  let n = 4
  k n
  return 25

It has also been mentioned that the type sigature of `callCC` is:

callCC :: ((a -> Cont r b) -> Cont r a) -> Cont r a
