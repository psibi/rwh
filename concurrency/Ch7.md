# Basic Concurrency: Threads and MVars

```
forkIO :: IO () -> IO ThreadId
```

The forkIO operation takes a computation of type IO () as its
argument; that is, a computation in the IO monad that eventually
delivers a value of type (). The computation passed to forkIO is
executed in a new thread that runs concurrently with the other threads
in the system. If the thread has effects, those effects will be
interleaved in an indeterminate fashion with the effects from other
threa

## MVar

``` haskell
data MVar a  -- abstract

newEmptyMVar :: IO (MVar a)
newMVar      :: a -> IO (MVar a)
takeMVar     :: MVar a -> IO a
putMVar      :: MVar a -> a -> IO ()
```

An MVar can be thought of as a box that is either empty or full. The
newEmptyMVar operation creates a new empty box, and newMVar creates a
new full box containing the value passed as its argument. The takeMVar
operation removes the value from a full MVar and returns it, but waits
(or blocks) if the MVar is currently empty. Symmetrically, the putMVar
operation puts a value into the MVar but blocks if the MVar is already
full.

## Uses of MVar

1. One-place channel
2. Container for shared mutable state
3. Building block for larger concurrent 

## One place channel - A logging service

API:

``` haskell
data Logger

initLogger :: IO Logger
logMessage :: Logger -> String -> IO ()
logStop    :: Logger -> IO ()
```

Implementation:

``` haskell
import Control.Concurrent (forkIO)
import Control.Concurrent.MVar

data Logger = Logger (MVar LogCommand)

data LogCommand = Message String
                | Stop (MVar ())

initLogger :: IO Logger
initLogger = do
  log <- newEmptyMVar
  let l = Logger log
  forkIO $ logger l
  return l

logger :: Logger -> IO ()
logger (Logger log) = loop
  where loop = do
          cmd <- takeMVar log
          case cmd of
            Message str -> putStrLn str >> loop
            Stop s -> putStrLn "logger stop" >> putMVar s () 

logMessage :: Logger -> String -> IO ()  
logMessage (Logger log) msg = do
  let logMsg = Message msg
  putMVar log logMsg

logStop :: Logger -> IO ()
logStop (Logger m) = do
  s <- newEmptyMVar
  putMVar m (Stop s)
  takeMVar s
```

One disadvantage of the above logger is that when multiple threads are
trying to log message at the same time, it won't be able to process it
fast.
