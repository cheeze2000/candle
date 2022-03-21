module Candle.Request
  ( Params
  , Request
  , Url
  , fromWaiRequest
  , reqBody
  , reqMethod
  , reqParams
  , reqQueries
  , reqUrl
  ) where

import qualified Data.ByteString.Lazy as B
import qualified Data.Text as T
import qualified Network.Wai as Wai

import Network.HTTP.Types (Method, QueryText, parseQueryText)
import Network.Wai (lazyRequestBody, pathInfo, rawQueryString, requestMethod)

type Body = IO B.ByteString
type Params = [(T.Text, T.Text)]
type Url = [T.Text]

data Request = Request
  { reqBody    :: Body
  , reqMethod  :: Method
  , reqParams  :: Params
  , reqQueries :: QueryText
  , reqUrl     :: Url
  }

fromWaiRequest :: Wai.Request -> Request
fromWaiRequest req = Request
  { reqBody    = lazyRequestBody req
  , reqMethod  = requestMethod req
  , reqParams  = mempty
  , reqQueries = parseQueryText $ rawQueryString req
  , reqUrl     = pathInfo req
  }
