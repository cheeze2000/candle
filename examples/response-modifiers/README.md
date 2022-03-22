```hs
{-# LANGUAGE OverloadedStrings #-}

import Candle

app :: Router
app = do
  get "/bold" $ do
    header ("Content-Type", "text/html")
    text "<b>Hello, World!</b>"
  get "/teapot" $ do
    status 418

main :: IO ()
main = listen 3000 app
```

```bash
$ curl "http://localhost:3000/bold"
# <b>Hello, World!</b>

$ curl -is http://localhost:3000/teapot | grep HTTP
# HTTP/1.1 418 I'm a teapot
```
