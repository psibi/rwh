import Data.Conduit
import qualified Data.Conduit.List as CL

main = do
  (rsrc1, result1) <- CL.sourceList [1..10] $$+ CL.take 3
  (rsrc2, result2) <- rsrc1 $$++ CL.take 3
  result3 <- rsrc2 $$+- CL.consume
  print (result1, result2, result3)
