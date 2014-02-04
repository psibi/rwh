import System.IO
import qualified Data.ByteString as S

main = do
  withFile "bracket.hs" ReadMode $ \input ->
    withFile "output.txt" WriteMode $ \output -> do
      bs <- S.hGetContents input
      S.hPutStr output bs
  S.readFile "output.txt" >>= S.putStr
    
