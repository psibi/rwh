add :: Int -> Int -> Int
add x y = x + y

square :: Int -> Int
square x = x * x

pythagoras :: Int -> Int -> Int
pythagoras x y = add (square x) (square y)

add_cps :: Int -> Int -> (Int -> r) -> r
add_cps x y = \k -> k (add x y)

square_cps :: Int -> (Int -> r) -> r
square_cps x = \k -> k (square x)

pythagoras_cps :: Int -> Int -> (Int -> r) -> r
pythagoras_cps x y = \k ->
  square_cps x $ \x_squared ->
  square_cps y $ \y_squared ->
  add_cps x_squared y_squared $ k

thrice :: (a -> a) -> a -> a
thrice f x = f $ f (f x)

thrice_cps :: (a -> (a -> r) -> r) -> a -> (a -> r) -> r
thrice_cps f_cps x = \k ->
  f_cps x $  \fx ->
  f_cps fx $ \ffx ->
  f_cps ffx $ k
