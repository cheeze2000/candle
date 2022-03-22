{-# LANGUAGE OverloadedStrings #-}

module Main where

import Candle

app :: Router
app = do
  get "/" $ do
    q <- query "q"
    text $ "Query: " <> q
  get "/:name" $ do
    name <- param "name"
    text $ "Param: " <> name
  post "/echo" $ do
    msg <- body
    bytes $ "Message: " <> msg

main :: IO ()
main = listen 3000 app
