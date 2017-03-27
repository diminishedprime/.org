import Control.Monad.Trans.Except
import Control.Monad.Trans.Maybe
import Control.Monad.Trans.Reader

embedded :: MaybeT (ExceptT String (ReaderT () IO)) Int
embedded = return 1
maybeUnwrap = runMaybeT embedded
eitherUnwrap = runExceptT maybeUnwrap
readerUnwrap = runReaderT eitherUnwrap

-- TODO: I haven't figured this one out yet
embedded' :: MaybeT (ExceptT String (ReaderT () IO)) Int
embedded' = _ (const (Right (Just 1)))
