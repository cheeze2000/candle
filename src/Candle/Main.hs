module Candle.Main
  ( listen
  ) where

import Control.Monad.Reader (runReaderT)
import Control.Monad.State.Strict (execState, execStateT)
import Network.Wai.Handler.Warp (Port, run)

import Candle.Handler (defaultHandler)
import Candle.Request (fromWaiRequest, reqParams)
import Candle.Response (defaultResponse, toWaiResponse)
import Candle.Router (Router, findRoute, routeHandler, routeParams)

listen :: Port -> Router -> IO ()
listen port router = do
  let routes = execState router mempty
  let app req res = do
        let req' = fromWaiRequest req
        let route = findRoute req' routes
        let params = maybe mempty routeParams route
        let handler = maybe defaultHandler routeHandler route
        res' <- execStateT (runReaderT handler $ req' { reqParams = params }) defaultResponse
        res $ toWaiResponse res'
  run port app
