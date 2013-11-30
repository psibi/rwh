
newtype Logger a = Logger { execLogger :: (a, Log)}

type Log = [String]

instance Monad Logger where
  return a = Logger (a, [])

  m >>= k = let (a, w) = execLogger m
                n = k a
                (b, x) = execLogger n
            in Logger (b, w ++ x)


