module Candle.Router
  ( Route
  , Router
  , Routes
  , findRoute
  , get
  , post
  , route
  , routeHandler
  , routeMethod
  , routeParams
  , routeUrl
  ) where

import qualified Data.Text as T
import qualified Data.Text.Encoding as T

import Control.Monad.State.Strict (State, modify)
import Data.Maybe (fromJust, isNothing)
import Network.HTTP.Types (Method, decodePathSegments, methodGet, methodPost)

import Candle.Handler (HandlerM)
import Candle.Request (Params, Request, Url, reqMethod, reqUrl)

type RequestUrl = Url
type RouteUrl = Url
type Router = State Routes ()
type Routes = [Route]

data Route = Route
  { routeHandler :: HandlerM ()
  , routeMethod  :: Method
  , routeParams  :: Params
  , routeUrl     :: RouteUrl
  }

findParams :: RequestUrl -> RouteUrl -> Maybe Params
findParams (x:xs) (y:ys)
  | T.head y == ':' = ((T.tail y, x) :) <$> findParams xs ys
  | x == y          = findParams xs ys
  | otherwise       = Nothing
findParams xs ys
  | null (xs <> ys) = Just mempty
  | xs == [T.empty] = Just mempty
  | ys == [T.empty] = Just mempty
  | otherwise       = Nothing

findRoute :: Request -> Routes -> Maybe Route
findRoute _ [] = Nothing
findRoute req (r:rs) =
  let
    params = findParams (reqUrl req) (routeUrl r)
  in
    if reqMethod req /= routeMethod r || isNothing params
      then findRoute req rs
      else Just $ r { routeParams = fromJust params }

route :: Method -> T.Text -> HandlerM () -> Router
route m t h = modify (r :)
  where
    r = Route { routeHandler = h, routeMethod = m, routeParams = mempty, routeUrl = u }
    u = decodePathSegments $ T.encodeUtf8 t

get :: T.Text -> HandlerM () -> Router
get = route methodGet

post :: T.Text -> HandlerM () -> Router
post = route methodPost
