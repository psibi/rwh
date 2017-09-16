palindrome : Nat -> String -> Bool
palindrome threshold st = (length st > threshold) && st' == Strings.reverse st'
  where
    st' = toLower st
