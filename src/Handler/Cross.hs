{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE NoImplicitPrelude #-}

module Handler.Cross where

import Database.Persist.Postgresql
import Import
import Text.Julius
import Text.Lucius (luciusFile)

getCrossR :: Handler Html
getCrossR = do
  defaultLayout $ do
    usuario <- lookupSession "_ID"
    addStylesheet (StaticR css_bootstrap_css)
    addStylesheet (StaticR css_estilo_css)
    -- toWidgetHead $(luciusFile "templates/Layout/header.julius")
    $(whamletFile "templates/Layout/header.hamlet")
    $(whamletFile "templates/Cross/cross.hamlet")
    $(whamletFile "templates/Layout/footer.hamlet")