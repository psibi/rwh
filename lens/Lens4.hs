data NaiveLens s a = NaiveLens
                      { view :: s -> a
                      , over :: (a -> a) -> s -> s
                      }

set :: NaiveLens s a -> a -> s -> s
set ln a s = over ln (const a) s
