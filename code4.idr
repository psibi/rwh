palindrome : String -> Bool
palindrome st = (length st > 10) && st' == Strings.reverse st'
  where
    st' = toLower st
