# Candle
Minimalist web framework written in Haskell

# WIP
This framework is still a work in progress with very minimal features and potential bugs.

# Usage
```hs
{-# LANGUAGE OverloadedStrings #-}

import Candle

app :: Router
app = do
  get "/bold" $ do
    msg <- query "q"
    header ("Content-Type", "text/html")
    text $ "Here's your bolded message: <b>" <> msg <> "</b>"
  get "/hello/:name" $ do
    name <- param "name"
    text $ "Hello " <> name <> "!"
  get "/teapot" $ do
    status 418
  post "/echo" $ do
    msg <- body
    bytes $ "You said: " <> msg

main :: IO ()
main = listen 3000 app
```
```bash
$ curl http://localhost:3000/bold/?q=candle
# Here's your bolded message: <b>candle</b>

$ curl http://localhost:3000/hello/cheeze
# Hello cheeze!

$ curl -is http://localhost:3000/teapot | grep HTTP
# HTTP/1.1 418 I'm a teapot

$ curl http://localhost:3000/echo -d "candle magic"
# You said: candle magic
```
