{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE NoImplicitPrelude #-}

module Handler.Foto where

import Database.Persist.Postgresql
import Import

getFotoR :: Handler Html
getFotoR = do
  usuario <- lookupSession "_ID"
  defaultLayout $ do
    usuario <- lookupSession "_ID"
    addStylesheet (StaticR css_bootstrap_css)
    addStylesheet (StaticR css_estilo_css)    
    $(whamletFile "templates/Layout/nav.hamlet") 
    $(whamletFile "templates/Layout/header.hamlet")
    $(whamletFile "templates/Fotos/foto.hamlet")
    $(whamletFile "templates/Layout/footer.hamlet")