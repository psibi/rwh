import Control.Monad

data Context = Home | Mobile | Business
             deriving (Show, Eq)

type Phone = String

albulena = [(Home, "7200120343")]

nils = [(Mobile, "3439439"), (Business, "349839482"),
        (Home, "394384393"), (Business, "4934839483")]

twalumba = [(Business, "3439483984")]

onePersonalPhone :: [(Context, Phone)] -> Maybe Phone
onePersonalPhone ps = case lookup Home ps of
                        Nothing -> lookup Mobile ps
                        Just x -> Just x

allBusinessPhone :: [(Context, Phone)] -> [Phone]
allBusinessPhone ps = map snd numbers
  where numbers = case filter (contextIs Business) ps of
                    [] -> filter (contextIs Mobile) ps
                    ns -> ns

contextIs a (b, _) = a == b

oneBusinessPhone :: [(Context, Phone)] -> Maybe Phone
oneBusinessPhone ps = lookup Business ps `mplus` lookup Mobile ps

allPersonalPhones :: [(Context, Phone)] -> [Phone]
allPersonalPhones ps = map snd $ filter (contextIs Home) ps `mplus`
                                 filter (contextIs Mobile) ps

x `zeroMod` n = guard ((x `mod` n) == 0) >> return x
