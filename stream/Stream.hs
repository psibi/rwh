newtype Generator a m r = Generator { nextG :: m (NextG a m r) }

data NextG a m r = YieldG a (Generator a m r)
                 | ReturnG r

stdin :: Generator String IO r
stdin = Generator $ do
  str <- getLine
  return $ YieldG str stdin

getFirst :: Generator a IO r -> IO (Maybe a)
getFirst g = do
  v <- nextG g
  case v of
    YieldG a _ -> return $ Just a
    ReturnG _ -> return Nothing

instance (Monad m) => Monad (Generator a m) where
  return = Generator . return . ReturnG
  (Generator xy) >>= f = Generator $ do
    v <- xy
    case v of
      ReturnG r -> nextG $ f r
      YieldG a g' -> return $ YieldG a (g' >>= f)

