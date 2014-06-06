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

responsibility :: Client -> String
responsibility (Company _ _ _ r) = r
responsibility _ = "Unknown"

specialClient :: Client -> Bool
specialClient (clientName -> "Sibi") = True
specialClient (responsibility -> "Director") = True
specialClient _ = False

data ClientR = GovOrgR {clientRName :: String }
             | CompanyR { clientRName :: String
                        , companyId :: String
                        , person :: PersonR
                        , duty :: String }
             | IndividualR { person :: PersonR }

data PersonR = PersonR { firstName :: String
                       , lastName :: String
                       } deriving (Show)               

