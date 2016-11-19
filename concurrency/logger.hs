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



