-- Infix constructor

data Something = Int :&^ Double

-- λ> let a = 3 :&^ 4.0
-- λ> :t a
-- a :: Something
