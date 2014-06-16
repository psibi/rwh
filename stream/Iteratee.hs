import Control.Applicative

data StreamG el = Empty | El el | EOF
data IterV el a = Done a (StreamG el)
                | Cont (StreamG el -> IterV el a)

-- enum function feeds data to IterV
enum :: IterV e1 a -> [e1] -> IterV e1 a
enum i [] = i
enum i@(Done _ _) _ = i
enum (Cont k) (x:xs) = enum (k (El x)) xs

-- run function to retrieve the final result
run :: IterV e1 a -> Maybe a
run (Done x _) = Just x
run (Cont k) = run' (k EOF)
  where run' (Done x _) = Just x
        run' _ = Nothing

head :: IterV e1 (Maybe e1)
head = Cont step
  where
    step (El e) = Done (Just e) Empty
    step EOF = Done Nothing EOF
    step Empty = Cont step

peek :: IterV e1 (Maybe e1)
peek = Cont step
  where
    step a@(El e) = Done (Just e) a
    step Empty = Cont step
    step EOF = Done Nothing EOF

dropi :: Int -> IterV e1 ()
dropi 0 = Done () Empty
dropi n = Cont step
  where
    step (El _) = dropi (n - 1)
    step Empty = Cont step
    step EOF = Done () Empty

length :: IterV e1 Int
length = Cont (step 0)
  where
    step acc (El _) = Cont $ step (acc + 1)
    step acc Empty = Cont $ step acc
    step acc EOF = Done acc EOF

instance Functor (IterV e1) where
  fmap f (Done x str) = Done (f x) str
  fmap f (Cont k) = Cont (fmap f . k)

instance Applicative (IterV e1) where
  pure x = Done x Empty
  (Done f str) <*> i2 = fmap f i2
  (Cont k) <*> i2 = Cont (\x -> k x <*> i2)

