import Control.Monad.State

import System.Random

twoBadRandoms :: RandomGen g => g -> (Int, Int)
twoBadRandoms gen = (fst $ random gen, fst $ random gen)

twoGoodRandoms :: RandomGen g => g -> (Int, Int)
twoGoodRandoms gen = let (a, g) = random gen
                     in (a, fst $ random g)

type RandomState a = State StdGen a

getRandom :: Random a => RandomState a
getRandom =
  get >>= \g ->
  let (a, g') = random g in
  put g' >> return a

dogetRandom :: Random a => RandomState a
dogetRandom = do
  gen <- get
  let (a, g') = random gen
  put g'
  return a

getTwoRandoms :: Random a => RandomState (a, a)
getTwoRandoms = liftM2 (,) getRandom getRandom

runTwoRandoms :: IO (Int, Int)
runTwoRandoms = do
  oldState <- getStdGen
  let (result, newState) = runState getTwoRandoms oldState
  setStdGen newState
  return result

data CountedRandom = CountedRandom {
  crGen :: StdGen,
  crCount :: Int
  }

type CRState = State CountedRandom

getCountedRandom :: Random a => CRState a
getCountedRandom = do
  st <- get
  let (val, gen') = random (crGen st)
  put CountedRandom { crGen = gen', crCount = crCount st + 1}
  return val

getCount :: CRState Int
getCount = liftM crCount get

putCount :: Int -> CRState ()
putCount a = do
  b <- get
  put b { crCount = a}
