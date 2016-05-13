module Paths_hangman (
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

bindir     = "/Users/mjhamrick/.org/reading-list/haskell_programming_from_first_principles/hangman/.stack-work/install/x86_64-osx/lts-5.16/7.10.3/bin"
libdir     = "/Users/mjhamrick/.org/reading-list/haskell_programming_from_first_principles/hangman/.stack-work/install/x86_64-osx/lts-5.16/7.10.3/lib/x86_64-osx-ghc-7.10.3/hangman-0.1.0.0-BBZpnRHCvuLIKle9bhE9C0"
datadir    = "/Users/mjhamrick/.org/reading-list/haskell_programming_from_first_principles/hangman/.stack-work/install/x86_64-osx/lts-5.16/7.10.3/share/x86_64-osx-ghc-7.10.3/hangman-0.1.0.0"
libexecdir = "/Users/mjhamrick/.org/reading-list/haskell_programming_from_first_principles/hangman/.stack-work/install/x86_64-osx/lts-5.16/7.10.3/libexec"
sysconfdir = "/Users/mjhamrick/.org/reading-list/haskell_programming_from_first_principles/hangman/.stack-work/install/x86_64-osx/lts-5.16/7.10.3/etc"

getBinDir, getLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "hangman_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "hangman_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "hangman_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "hangman_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "hangman_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
