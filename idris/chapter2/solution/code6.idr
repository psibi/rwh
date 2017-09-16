counts : String -> (Nat, Nat)
counts st = let
            w = words st
            c = unpack st
            in (length w, length c)
