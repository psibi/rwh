
newtype Logger a = Logger { execLogger :: (a, Log)}

type Log = [String]

instance Monad Logger where
  return a = Logger (a, [])

  m >>= k = let (a, w) = execLogger m
                n = k a
                (b, x) = execLogger n
            in Logger (b, w ++ x)

record :: String -> Logger ()
record s = Logger ((), [s])

-- Sample List monad demo

guarded :: Bool -> [a] -> [a]
guarded True xs = xs
guarded False _ = []


multiplyTo :: Int -> [(Int, Int)]
multiplyTo n = do
  x <- [1..n]
  y <- [1..n]
  guarded (x * y == n) $
    return (x, y)

