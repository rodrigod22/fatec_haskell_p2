{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE NoImplicitPrelude #-}

module Handler.Foto where

import Database.Persist.Postgresql
import Import
import Text.Julius
import Text.Lucius (luciusFile)

getFotoR :: Handler Html
getFotoR = do
  defaultLayout $ do
    addStylesheet (StaticR css_bootstrap_css)
    addStylesheet (StaticR css_estilo_css)
    -- toWidgetHead $(luciusFile "templates/Layout/header.julius")
    $(whamletFile "templates/Layout/header.hamlet")
    $(whamletFile "templates/Layout/footer.hamlet")