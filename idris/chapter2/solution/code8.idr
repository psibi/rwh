over_length : Nat -> List String -> Nat
over_length n xs = length $ filter (\x : Nat => x > n ) $ map length xs
