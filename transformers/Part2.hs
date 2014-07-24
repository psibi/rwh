data User = User deriving Show

findById :: Int -> Maybe User
findById 1 = Just User
findById _ = Nothing

loadUsers :: Maybe (User, User)
loadUsers = do
  user1 <- findById 1
  user2 <- findById 2
  return (user1, user2)
