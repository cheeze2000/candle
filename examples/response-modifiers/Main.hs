{-# LANGUAGE OverloadedStrings #-}

module Main where

import Candle

app :: Router
app = do
  get "/bold" $ do
    header "Content-Type" "text/html"
    text "<b>Hello, World!</b>"
  get "/teapot" $ do
    status 418

main :: IO ()
main = listen 3000 app
