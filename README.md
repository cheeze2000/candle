# Candle
Minimalist web framework written in Haskell

# WIP
This framework is still a work in progress with very minimal features and potential bugs.

# Examples
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
For more examples, click [here](examples).
