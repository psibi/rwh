import Control.Monad (liftM)

data Toy b next =
    Output b next
  | Bell next
  | Done
    deriving (Show)

data Cheat f = Cheat1 (f (Cheat f))

data Dummy f = Dummy (Maybe f) deriving (Show)

-- λ> let a = Cheat1 (Output 'a' (Cheat1 Done))
-- λ> :t a
-- a :: Cheat (Toy Char)

data FixE f e = Fix (f (FixE f e)) | Throw e

catch :: (Functor f) => FixE f e1 -> (e1 -> FixE f e2) -> FixE f e2
catch (Fix x) f = Fix (fmap (flip catch f) x)
catch (Throw e) f = f e

-- fmap :: (a -> b) -> Toy c a -> Toy c b

instance Functor (Toy c) where
  fmap f (Output b next) = Output b (f next)
  fmap f (Bell next) = Bell (f next)
  fmap f Done = Done

data IncompleteException = IncompleteException

subroutine' = Fix (Output 'A' (Throw IncompleteException)) :: FixE (Toy Char) IncompleteException

program' = subroutine' `catch` (\_ -> Fix (Bell (Fix Done))) :: FixE (Toy Char) e

data Free f r = Free (f (Free f r)) | Pure r

instance (Functor f) => Monad (Free f) where
  return = Pure
  (Pure r) >>= f = f r
  (Free x) >>= f = Free $ fmap (\y -> y >>= f) x

output' :: a -> Free (Toy a) ()
output' x = Free (Output x (Pure ()))

bell' :: Free (Toy a) ()
bell' = Free $ Bell (Pure ())

done' :: Free (Toy a) r
done' = Free Done

liftF :: (Functor f) => f r -> Free f r
liftF command = Free $ fmap Pure command

output x = liftF (Output x ())
bell = liftF (Bell ())
done = liftF Done

subroutine :: Free (Toy Char) ()
subroutine = output 'A'

program :: Free (Toy Char) r
program = do
  subroutine
  bell
  done

showProgram :: (Show a, Show r) => Free (Toy a) r -> String
showProgram (Free (Output a x)) = "output " ++ show a ++ "\n" ++ showProgram x
showProgram (Free (Bell x)) = "bell\n" ++ showProgram x
showProgram (Free Done) = "done\n"
showProgram (Pure r) = "return " ++ show r ++ "\n"

pretty :: (Show a, Show r) => Free (Toy a) r -> IO ()
pretty = putStrLn . showProgram

data Thread m r = Atomic (m (Thread m r)) | Return r

atomic :: (Monad m) => m a -> Thread m a
atomic x = Atomic (liftM Return x)

instance (Monad m) => Monad (Thread m) where
  return = Return
  (Atomic m) >>= f = Atomic (liftM (>>= f) m)
  (Return r) >>= f = f r
