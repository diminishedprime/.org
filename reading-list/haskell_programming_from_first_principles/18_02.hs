import Control.Monad (join)
-- The answer is the exercise Write bind in terms of fmap and join. Fear is the
-- mind-killer, friend. You can do it.

bind :: Monad m => (a -> m b) -> m a -> m b
bind f = join . fmap f
