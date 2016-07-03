module Paths_ch24_s03 (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/Users/mjhamrick/.org/reading-list/haskell_programming_from_first_principles/ch24-s03/.stack-work/install/x86_64-osx/lts-6.4/7.10.3/bin"
libdir     = "/Users/mjhamrick/.org/reading-list/haskell_programming_from_first_principles/ch24-s03/.stack-work/install/x86_64-osx/lts-6.4/7.10.3/lib/x86_64-osx-ghc-7.10.3/ch24-s03-0.1.0.0-Ify22svvvPE30VhAdFHf2j"
datadir    = "/Users/mjhamrick/.org/reading-list/haskell_programming_from_first_principles/ch24-s03/.stack-work/install/x86_64-osx/lts-6.4/7.10.3/share/x86_64-osx-ghc-7.10.3/ch24-s03-0.1.0.0"
libexecdir = "/Users/mjhamrick/.org/reading-list/haskell_programming_from_first_principles/ch24-s03/.stack-work/install/x86_64-osx/lts-6.4/7.10.3/libexec"
sysconfdir = "/Users/mjhamrick/.org/reading-list/haskell_programming_from_first_principles/ch24-s03/.stack-work/install/x86_64-osx/lts-6.4/7.10.3/etc"

getBinDir, getLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "ch24_s03_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "ch24_s03_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "ch24_s03_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "ch24_s03_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "ch24_s03_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
