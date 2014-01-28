-- Examples from Mother of All Monads!
-- http://blog.sigfpe.com/2008/12/mother-of-all-monads.html

import Continuation -- Continutaion Monad

-- ex1 :: Maybe Int
-- ex1 :: [Int]
-- ex1 :: Cont String Int

ex1 = do
  a <- return 1
  b <- return 10
  return $ a + b

ex2 = do
  a <- return 1
  b <- Cont (\fred -> fred 10)
  return $ a + b

ex3 = do
  a <- return 1
  b <- Cont (\fred -> "escape")
  return $ a + b

ex4 = do
  a <- return 1
  b <- Cont (\fred -> fred 10 ++ fred 20)
  return $ a + b

ex5 = do
  a <- return 1
  b <- [10,20]
  return $ a + b

ex6 = do
  a <- return 1
  b <- Cont (\fred -> concat [fred 10, fred 20])
  return $ a + b

ex8 = do
  a <- return 1
  b <- Cont (\fred -> [10, 20] >>= fred)
  return $ a + b

i x = Cont (\fred -> x >>= fred)
run m = runCont m return

test9 = run $ do
  a <- i [1, 2]
  b <- i [10, 12]
  return $ a + b
  

test1 = runCont ex1 show
test3 = runCont ex3 show
test4 = runCont ex4 show
test6 = runCont ex6 (\x -> [x])
test8 = runCont ex8 return
