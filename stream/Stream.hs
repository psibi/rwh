import Control.Monad
import Control.Monad.Trans.Class

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

yieldG :: (Monad m) => a -> Generator a m ()
yieldG x = Generator $ return  $ YieldG x (return ())

instance MonadTrans (Generator a) where
  lift m = Generator $ do
    r <- m
    return (ReturnG r)

echoandLoop :: Generator String IO r
echoandLoop = do
  str <- lift getLine
  yieldG str
  forever $ yieldG "all"

display1 :: Int -> Generator String IO r -> IO ()
display1 0 _ = return ()
display1 n g = do
  x <- nextG g
  case x of
    ReturnG _ -> return ()
    YieldG str g' -> do
      putStrLn str
      display1 (n - 1) g'

newtype Sink a m r = Sink { nextS :: m (NextS a m r) }

data NextS a m r = ReturnS r
                 | AwaitS (a -> Sink a m r)

instance (Monad m) => Monad (Sink a m) where
  return x = Sink $ return $ ReturnS x
  s >>= f = Sink $ do
    a <- nextS s
    case a of
      ReturnS r -> nextS $ f r
      AwaitS k -> return $ AwaitS $ \b -> k b >>= f

instance MonadTrans (Sink a) where
  lift m = Sink $ do
    x <- m
    return (ReturnS x)

awaitS :: (Monad m) => Sink a m a
awaitS =  Sink $ return $ AwaitS (\x -> Sink $ return $ (ReturnS x))
  
