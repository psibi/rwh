import Control.Concurrent

notQuiteRight = do
  mv <- newEmptyMVar
  forkIO $ expensiveComputation mv
  someOtherActivity
  result <- takeMVar mv
  print result

someOtherActivity = putStrLn "Some other activity"

expensiveComputation mv = do
  let a = "this is "
      b = "not really"
      c = "all that expensive"
  putMVar mv (a ++ b ++ c)
