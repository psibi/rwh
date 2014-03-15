{-# LANGUAGE ExistentialQuantification #-}

data ShowBox = forall s. Show s => SB s

instance Show ShowBox where
  show (SB a) = show a
  

heteroList :: [ShowBox]
heteroList = [SB 3, SB "hi", SB True, SB ()]
