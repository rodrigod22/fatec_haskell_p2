{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE NoImplicitPrelude #-}

module Handler.Home where

import Database.Persist.Postgresql
import Import

getHomeR :: Handler Html
getHomeR = do
  usuario <- lookupSession "_ID"
  defaultLayout $ do
    addStylesheet (StaticR css_bootstrap_css)
    addStylesheet (StaticR css_all_css)    
    addStylesheet (StaticR css_estilo_css) 
    $(whamletFile "templates/Layout/nav.hamlet") 
    $(whamletFile "templates/Layout/header.hamlet")  
    $(whamletFile "templates/Home/home.hamlet")
    $(whamletFile "templates/Layout/footer.hamlet")