{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE NoImplicitPrelude #-}

module Handler.Doacao where

import Database.Persist.Postgresql
import Import
import Text.Julius
import Text.Lucius (luciusFile)

getDoacaoR :: Handler Html
getDoacaoR = do
  defaultLayout $ do
    usuario <- lookupSession "_ID"
    addStylesheet (StaticR css_bootstrap_css)
    addStylesheet (StaticR css_estilo_css)
    -- toWidgetHead $(luciusFile "templates/Layout/header.julius")
    $(whamletFile "templates/Layout/header.hamlet")
    $(whamletFile "templates/Doacao/doacao.hamlet")
    $(whamletFile "templates/Layout/footer.hamlet")