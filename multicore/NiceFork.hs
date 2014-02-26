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


