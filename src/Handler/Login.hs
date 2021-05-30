{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE NoImplicitPrelude #-}

module Handler.Login where

import Handler.Auxiliar (formWidget)
import Import
import Text.Lucius (luciusFile)

formLogin :: Form Usuario
formLogin =
  renderDivs $
    Usuario
      <$> areq
        textField
        ( FieldSettings
            "E-Mail"
            Nothing
            (Just "n1")
            Nothing
            [("class", "form-control")]
        )
        Nothing
      <*> areq
        passwordField
        ( FieldSettings
            "Senha"
            Nothing
            (Just "n2")
            Nothing
            [("class", "form-control")]
        )
        Nothing

getAutR :: Handler Html
getAutR = do
  (widget, _) <- generateFormPost formLogin
  msg <- getMessage
  defaultLayout $ do
    usuario <- lookupSession "_ID"
    toWidgetHead $(luciusFile "templates/Login/login.lucius")
    addStylesheet (StaticR css_bootstrap_css)
    addStylesheet (StaticR css_estilo_css)
    $(whamletFile "templates/Layout/nav.hamlet")
    $(whamletFile "templates/Login/header.hamlet")
    (formWidget widget msg AutR "Entrar")

postAutR :: Handler Html
postAutR = do
  ((result, _), _) <- runFormPost formLogin
  case result of
    FormSuccess (Usuario "root@root.com" "root") -> do
      setSession "_ID" "admin"
      redirect AdminR
    FormSuccess (Usuario email senha) -> do
      usuarioExiste <- runDB $ getBy (UniqueEmailIx email)
      case usuarioExiste of
        Nothing -> do
          setMessage
            [shamlet|
              <div>
                Usuario não cadastrado !
          |]
          redirect AutR
        Just (Entity _ usuario) -> do
          if senha == usuarioSenha usuario
            then do
              setSession "_ID" (usuarioEmail usuario)
              redirect HomeR
            else do
              setMessage
                [shamlet|
                  <div>
                    Usuario e ou senha invalidos !!!
              |]
              redirect AutR
    _ -> redirect HomeR

postSairR :: Handler Html
postSairR = do
  deleteSession "_ID"
  redirect HomeR

getAdminR :: Handler Html
getAdminR = do
  defaultLayout
    [whamlet|

    BEM VINDO ADMIN
  |]