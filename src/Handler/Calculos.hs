{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE NoImplicitPrelude #-}

module Handler.Calculos where

import Import

getSomarR :: Int -> Int -> Handler Html
getSomarR n1 n2 = do
  defaultLayout $ do
    res <- return (n1 + n2)
    [whamlet|
      <h1>
        A soma he #{res} 
    |]
