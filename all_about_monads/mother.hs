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

test1 = runCont ex1 show  
