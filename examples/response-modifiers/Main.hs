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
  get "/readme" $ do
    file "./README.md"

main :: IO ()
main = listen 3000 app
