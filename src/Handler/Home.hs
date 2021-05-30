{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE NoImplicitPrelude #-}

module Handler.Home where

import Database.Persist.Postgresql
import Import
import Text.Julius
import Text.Lucius (luciusFile)

getHomeR :: Handler Html
getHomeR = do
  defaultLayout $ do
    usuario <- lookupSession "_ID"
    addStylesheet (StaticR css_bootstrap_css)
    addStylesheet (StaticR css_estilo_css)
    $(whamletFile "templates/Layout/header.hamlet")
    $(whamletFile "templates/Home/home.hamlet")
    $(whamletFile "templates/Layout/footer.hamlet")