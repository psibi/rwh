{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FunctionalDependencies #-}

--- Doesn't actually follow the tutorial, I use functional
--- dependencies as opposed to the tutorial.


import Data.Tuple (swap)

data Fire = Charmander | Charmeleon | Charizard deriving Show
data Water = Squirtle | Wartortle | Blastoise deriving Show
data Grass = Bulbasaur | Ivysaur | Venusaur deriving Show

data FireMove = Ember | FlameThrower | FireBlast deriving Show
data WaterMove = Bubble | WaterGun deriving Show
data GrassMove = VineWhip deriving Show

class (Show pokemon, Show move) => Pokemon pokemon move | pokemon -> move where
  pickMove :: pokemon -> move

instance Pokemon Fire FireMove where
  pickMove Charmander = Ember
  pickMove Charmeleon = FlameThrower
  pickMove Charizard = FireBlast

instance Pokemon Water WaterMove where
  pickMove Squirtle = Bubble
  pickMove _ = WaterGun

instance Pokemon Grass GrassMove where
  pickMove _ = VineWhip

class (Pokemon pokemon move, Pokemon foe foeMove) => Battle pokemon move foe foeMove | pokemon -> move, foe -> foeMove where
  battle :: pokemon -> foe -> IO ()
  battle pokemon foe = do
    printBattle (show pokemon) (show move) (show foe) (show foeMove) (show pokemon)
   where
    move = pickMove pokemon
    foeMove = pickMove foe

instance Battle Water WaterMove Fire FireMove
instance Battle Fire FireMove Water WaterMove
instance Battle Grass GrassMove Water WaterMove
instance Battle Water WaterMove Grass GrassMove  
instance Battle Fire FireMove Grass GrassMove
instance Battle Grass GrassMove Fire FireMove

printBattle :: String -> String -> String -> String -> String -> IO ()
printBattle pokemonOne moveOne pokemonTwo moveTwo winner = do
  putStrLn $ pokemonOne ++ " used " ++ moveOne
  putStrLn $ pokemonTwo ++ " used " ++ moveTwo
  putStrLn $ "Winner is: " ++ winner ++ "\n"

main :: IO ()
main = do
  battle Squirtle Charmander 
