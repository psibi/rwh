type SimpleState s a = s -> (a, s)

returnSt :: a -> SimpleState s a
returnSt a = \s -> (a,s)

returnAlt :: a -> SimpleState s a
returnAlt a s = (a, s)

bindSt :: SimpleState s a -> (a -> SimpleState s b) -> SimpleState s b
bindSt m k = \s -> let (a, s') = m s
                   in (k a) s'

bindAlt :: SimpleState s a -> (a -> SimpleState s b) -> SimpleState s b
bindAlt step makeStep oldState =
  let (result, newState) = step oldState
  in (makeStep result) newState

getSt :: SimpleState s s
getSt = \s -> (s, s)

putSt :: s -> SimpleState s ()
putSt s = \_ -> ((), s)


-- Some Examples:

-- ghci > let a = putSt 3 >>= (\i ->  return i)
-- ghci > a 9
-- ((),3)
-- ghci > a undefined
-- ((),3)
