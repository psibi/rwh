import Control.Concurrent
import Control.Exception
import qualified Data.Map as M

data ThreadStatus = Running
                  | Finished
                  | Threw SomeException
                    deriving (Show)

newtype ThreadManager = Mgr (MVar (M.Map ThreadId (MVar ThreadStatus)))

newManager :: IO ThreadManager
newManager = Mgr `fmap` newMVar M.empty

forkManaged :: ThreadManager -> IO () -> IO ThreadId
forkManaged (Mgr mgr) body =
  modifyMVar mgr $ \m -> do
    state <- newEmptyMVar
    tid <- forkIO $ do
      result <- try body
      putMVar state (either Threw (const Finished) result)
    return (M.insert tid state m, tid)

getStatus :: ThreadManager -> ThreadId -> IO (Maybe ThreadStatus)
getStatus (Mgr mgr) tid =
  modifyMVar mgr $ \m ->
    case M.lookup tid m of
      Nothing -> return (m, Nothing)
      Just st -> tryTakeMVar st >>= \mst -> case mst of
        Nothing -> return (m, Just Running)
        Just sth -> return (M.delete tid m, Just sth)
  
                          


