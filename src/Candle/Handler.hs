module Candle.Handler
  ( HandlerM
  , body
  , bytes
  , defaultHandler
  , header
  , param
  , query
  , status
  , text
  ) where

import qualified Data.ByteString.Lazy as B
import qualified Data.Text as T
import qualified Data.Text.Encoding as T

import Control.Monad.IO.Class (liftIO)
import Control.Monad.Reader (ReaderT, ask)
import Control.Monad.State.Strict (StateT, modify)
import Data.List (find)
import Data.Maybe (fromMaybe)

import Candle.Request (Request, reqBody, reqParams, reqQueries)
import Candle.Response (Response, resBody, resHeaders, resStatus)

type HandlerM = ReaderT Request (StateT Response IO)

defaultHandler :: HandlerM ()
defaultHandler = status 404

body :: HandlerM B.ByteString
body = do
  req <- ask
  liftIO $ reqBody req

param :: T.Text -> HandlerM T.Text
param key = do
  req <- ask
  let ps = reqParams req
  return . maybe T.empty snd $ find (\p -> fst p == key) ps

query :: T.Text -> HandlerM T.Text
query key = do
  req <- ask
  let qs = reqQueries req
  return . fromMaybe T.empty $ snd =<< find (\q -> fst q == key) qs

bytes :: B.ByteString -> HandlerM ()
bytes b = modify (\res -> res { resBody = b })

header :: T.Text -> T.Text -> HandlerM ()
header a b = modify (\res -> let hs = resHeaders res in res { resHeaders = (a, b) : hs })

status :: Int -> HandlerM ()
status n = modify (\res -> res { resStatus = n })

text :: T.Text -> HandlerM ()
text = bytes . B.fromStrict . T.encodeUtf8
