data IOAction a = Return a
                | Put String (IOAction a)
                | Get (String -> IOAction a)

put :: String -> IOAction ()
put s = Put s (Return ())                  

get :: IOAction String
get = Get (\s -> Return s)

seqio :: IOAction a -> (a -> IOAction b) -> IOAction b
seqio (Return a) f = f a
seqio (Put s a) f = Put s (a `seqio` f)
seqio (Get g) f = Get (\s -> g s `seqio` f)

echo :: IOAction ()
echo = get `seqio` put

hello :: IOAction ()
hello = put "What is your name?"      `seqio` \_    ->
        get                           `seqio` \name ->
        put "What is your age?"       `seqio` \_    ->
        get                           `seqio` \age  ->
        put ("Hello " ++ name ++ "!") `seqio` \_    ->
        put ("You are " ++ age ++ " years old")


instance Monad IOAction where
  return = Return
  (>>=) = seqio

run :: IOAction a -> IO a
run (Return a) = return a
run (Put s io) = print s >> run io
run (Get f) = getLine >>= \s -> run (f s)


