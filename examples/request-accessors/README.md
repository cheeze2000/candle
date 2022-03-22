```hs
{-# LANGUAGE OverloadedStrings #-}

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
```

```bash
$ curl "http://localhost:3000/?q=hello"
# Query: hello

$ curl "http://localhost:3000/hello"
# Param: hello

$ curl "http://localhost:3000/echo" -d "hello"
# Message: hello
```
