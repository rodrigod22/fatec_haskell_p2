{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE NoImplicitPrelude #-}

module Handler.Usuario where

import Handler.Auxiliar (formWidget)
import Import
import Text.Julius
import Text.Lucius (luciusFile)

formLogin :: Form (Usuario, Text)
formLogin =
  renderDivs $
    (,)
      <$> ( Usuario
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
          )
      <*> areq
        passwordField
        ( FieldSettings
            "Confirmação"
            Nothing
            (Just "n3")
            Nothing
            [("class", "form-control")]
        )
        Nothing

getUsuarioR :: Handler Html
getUsuarioR = do
  (widget, _) <- generateFormPost formLogin
  msg <- getMessage
  defaultLayout $ do
    usuario <- lookupSession "_ID"
    toWidgetHead $(luciusFile "templates/Usuario/usuario.lucius")
    addStylesheet (StaticR css_bootstrap_css)
    addStylesheet (StaticR css_estilo_css)
    $(whamletFile "templates/Layout/header.hamlet")
    $(whamletFile "templates/Usuario/header.hamlet")
    (formWidget widget msg UsuarioR "Cadastrar")
    $(whamletFile "templates/Layout/footer.hamlet")

postUsuarioR :: Handler Html
postUsuarioR = do
  ((result, _), _) <- runFormPost formLogin
  case result of
    FormSuccess (usuario@(Usuario email senha), conf) -> do
      usuarioExiste <- runDB $ getBy (UniqueEmailIx email)
      case usuarioExiste of
        Just _ -> do
          setMessage
            [shamlet|
              <div>
                Email já cadastrado !
          |]
          redirect UsuarioR
        Nothing -> do
          if senha == conf
            then do
              runDB $ insert usuario
              setMessage
                [shamlet|
                  <div>
                    Usuario incluido com sucesso !
              |]
              redirect UsuarioR
            else do
              setMessage
                [shamlet|

                <div>
                  Confirmação diferente de senha !
            |]
              redirect UsuarioR
    _ -> redirect HomeR
