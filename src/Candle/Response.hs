{-# LANGUAGE RecordWildCards #-}

module Candle.Response
  ( Response
  , defaultResponse
  , resBody
  , resHeaders
  , resStatus
  , toWaiResponse
  ) where

import qualified Data.ByteString.Lazy as B
import qualified Data.Text as T
import qualified Data.Text.Encoding as T
import qualified Network.Wai as Wai

import Data.CaseInsensitive (mk)

type Body = B.ByteString
type Headers = [(T.Text, T.Text)]
type Status = Int

data Response = Response
  { resBody    :: Body
  , resHeaders :: Headers
  , resStatus  :: Status
  }

defaultResponse :: Response
defaultResponse = Response
  { resBody    = B.empty
  , resHeaders = mempty
  , resStatus  = 200
  }

toWaiResponse :: Response -> Wai.Response
toWaiResponse Response{..} = Wai.responseLBS s h resBody
  where
    h = map (\(k, v) -> (mk $ T.encodeUtf8 k, T.encodeUtf8 v)) resHeaders
    s = toEnum resStatus
