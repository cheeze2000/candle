{-# LANGUAGE OverloadedStrings #-}

module Main where

import Candle

app :: Router
app = do
  get "/" $ do
    text "Hello, World!"

main :: IO ()
main = listen 3000 app
