data Client = GovOrg String
            | Company String Integer Person String
            | Individual Person Bool
            deriving (Show)

data Person = Person String String
            deriving (Show)

data Gender = Male | Female | Unknown deriving Show

clientName :: Client -> String
clientName client = case client of
  GovOrg name -> name
  Company name _ _ _ -> name
  Individual person _ -> case person of
    Person fname lname -> fname ++ " " ++ lname
