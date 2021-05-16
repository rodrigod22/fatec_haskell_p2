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

getFotoR :: Handler Html
getFotoR = do
  defaultLayout $ do
    addStylesheet (StaticR css_bootstrap_css)
    addStylesheet (StaticR css_estilo_css)
    -- toWidgetHead $(luciusFile "templates/Layout/header.julius")
    $(whamletFile "templates/Layout/header.hamlet")
    $(whamletFile "templates/Fotos/foto.hamlet")
    $(whamletFile "templates/Layout/footer.hamlet")

getCrossR :: Handler Html
getCrossR = do
  defaultLayout $ do
    addStylesheet (StaticR css_bootstrap_css)
    addStylesheet (StaticR css_estilo_css)
    -- toWidgetHead $(luciusFile "templates/Layout/header.julius")
    $(whamletFile "templates/Layout/header.hamlet")
    $(whamletFile "templates/Cross/cross.hamlet")
    $(whamletFile "templates/Layout/footer.hamlet")

getDoacaoR :: Handler Html
getDoacaoR = do
  defaultLayout $ do
    addStylesheet (StaticR css_bootstrap_css)
    addStylesheet (StaticR css_estilo_css)
    -- toWidgetHead $(luciusFile "templates/Layout/header.julius")
    $(whamletFile "templates/Layout/header.hamlet")

    $(whamletFile "templates/Doacao/doacao.hamlet")
    $(whamletFile "templates/Layout/footer.hamlet")

getHomeR :: Handler Htmlddfdfd
getHomeR = do
  defaultLayout $ do
    addStylesheet (StaticR css_bootstrap_css)
    addStylesheet (StaticR css_estilo_css)
    -- toWidgetHead $(luciusFile "templates/Layout/header.julius")
    $(whamletFile "templates/Layout/header.hamlet")
    $(whamletFile "templates/Home/home.hamlet")
    $(whamletFile "templates/Layout/footer.hamlet")
