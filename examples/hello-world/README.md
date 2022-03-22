```hs
{-# LANGUAGE OverloadedStrings #-}

import Candle

app :: Router
app = do
  get "/" $ do
    text "Hello, World!"

main :: IO ()
main = listen 3000 app
```

```bash
$ curl "http://localhost:3000"
# Hello, World!
```
