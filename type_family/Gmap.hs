{-# LANGUAGE TypeFamilies #-}

import Data.IntMap

class GMapKey k where
  data GMap k :: * -> *
  empty :: GMap k v
  lookup :: k -> GMap k v -> Maybe v
  insert :: k -> v -> GMap k v -> GMap k v

instance GMapKey Int where
  data GMap Int v = GMapInt (Data.IntMap.IntMap v)
  empty = GMapInt Data.IntMap.empty
  lookup k (GMapInt m) = Data.IntMap.lookup k m
  insert k v (GMapInt m) = GMapInt (Data.IntMap.insert k v m)
  
