{-# LANGUAGE QuasiQuotes, TypeFamilies, GeneralizedNewtypeDeriving, TemplateHaskell,
             OverloadedStrings, GADTs, FlexibleContexts #-}
import Database.Persist
import Database.Persist.Sqlite
import Database.Persist.TH
import Data.Time

share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistLowerCase|
Person sql=the-person-table id=numeric_id
    firstName String sql=first_name
    lastName String sql=fldLastName
    age Int Gt Desc "sql=The Age of the Person"
    UniqueName firstName lastName
    deriving Show
|]

main = runSqlite ":memory:" $ do
    runMigration migrateAll

-- Output: Migrating: CREATE TABLE "the-person-table"("numeric_id" INTEGER PRIMARY KEY,"first_name" VARCHAR NOT NULL,"fldLastName" VARCHAR NOT NULL,"The Age of the Person" INTEGER NOT NULL,CONSTRAINT "unique_name" UNIQUE ("first_name","fldLastName"))
