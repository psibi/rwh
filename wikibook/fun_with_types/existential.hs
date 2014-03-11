{-# LANGUAGE ExistentialQuantification #-}

data ShowBox = forall s. Show s => SB s

heteroList :: [ShowBox]
heteroList = [SB 3, SB "hi", SB True, SB ()]
