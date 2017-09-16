palindrome : String -> Bool
palindrome st = st' == Strings.reverse st'
  where
    st' = toLower st
