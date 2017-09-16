palindrome : String -> Bool
palindrome st = st == reverse st

main : IO ()
main = repl "pal> " ((++ "\n") . show . palindrome)
