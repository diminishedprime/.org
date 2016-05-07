import Data.List

data OperatingSystem =
  GnuPlusLinux
  | OpenBSDPlusNevermindJustBSDStill | Mac
  | Windows
  deriving (Eq, Show)

data ProgrammingLanguage =
  Haskell
  | Agda
  | Idris
  | PureScript deriving (Eq, Show)

data Programmer =
  Programmer { os :: OperatingSystem
             , lang :: ProgrammingLanguage }
  deriving (Eq, Show)

-- Exercise

-- Write a function that generates all possible values of Programmer. Use the
-- provided lists of inhabitants of OperatingSystem and Program- mingLanguage.

allOperatingSystems :: [OperatingSystem]
allOperatingSystems =
  [ GnuPlusLinux
  , OpenBSDPlusNevermindJustBSDStill
  , Mac
  , Windows]

allLanguages :: [ProgrammingLanguage]
allLanguages =
  [ Haskell
  , Agda
  , Idris
  , PureScript]

allProgrammers :: [Programmer]
allProgrammers = nub [Programmer { os = currOs
                                 , lang = currLang}
                     | currOs <- allOperatingSystems
                     , currLang <- allLanguages]
