import System.Process

job = createProcess (proc "/home/sibi/github/rwh/multicore/job.sh" [])

main = do
  a <- job
  return ()
