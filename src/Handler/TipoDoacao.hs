{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE NoImplicitPrelude #-}

module Handler.TipoDoacao where

import Handler.Auxiliar
import Import

formTipoDoacao :: Maybe TipoDoacao -> Form TipoDoacao
formTipoDoacao mc =
  renderDivs $ TipoDoacao     
      <$> areq
        textField
        ( FieldSettings
            "Descrição"
            Nothing
            (Just "n2")
            Nothing
            [("class", "form-control")]
        )
        (fmap tipoDoacaoDescricao mc)
      <*> areq
        intField
        ( FieldSettings
            "Cupons"
            Nothing
            (Just "n3")
            Nothing
            [("class", "form-control")]
        )
        (fmap tipoDoacaoCupons mc)

getTipoDoacaoR :: Handler Html
getTipoDoacaoR = do
  (widget, _) <- generateFormPost (formTipoDoacao Nothing)
  msg <- getMessage
  usuario <- lookupSession "_ID"
  defaultLayout $ do   
    addStylesheet (StaticR css_bootstrap_css)
    addStylesheet (StaticR css_estilo_css)
    $(whamletFile "templates/Layout/nav.hamlet")
    $(whamletFile "templates/Layout/header.hamlet")
    $(whamletFile "templates/TipoDoacao/tituloCadastro.hamlet")
    (formWidget widget msg TipoDoacaoR "Cadastrar")
    $(whamletFile "templates/Layout/footer.hamlet")

postTipoDoacaoR :: Handler Html
postTipoDoacaoR = do
  ((result, _), _) <- runFormPost (formTipoDoacao Nothing)
  case result of
    FormSuccess tipoDoacao -> do
      runDB $ insert tipoDoacao
      setMessage
        [shamlet|
        <div>
          Tipo incluido com sucesso !
      |]
      redirect TipoDoacaoR
    _ -> redirect HomeR

getTipoDoacaoPerfilR :: TipoDoacaoId -> Handler Html
getTipoDoacaoPerfilR cid = do
  tipoDoacao <- runDB $ get404 cid
  usuario <- lookupSession "_ID"
  defaultLayout $ do    
    addStylesheet (StaticR css_bootstrap_css)
    addStylesheet (StaticR css_estilo_css)
    $(whamletFile "templates/Layout/nav.hamlet")
    $(whamletFile "templates/Layout/header.hamlet")
    $(whamletFile "templates/TipoDoacao/perfil.hamlet")
    $(whamletFile "templates/Layout/footer.hamlet")

getListaTipoR :: Handler Html
getListaTipoR = do
  tiposDoacao <- runDB $ selectList [] [Asc TipoDoacaoDescricao]
  usuario <- lookupSession "_ID"
  defaultLayout $ do
    addStylesheet (StaticR css_bootstrap_css)
    addStylesheet (StaticR css_estilo_css)
    $(whamletFile "templates/Layout/nav.hamlet")
    $(whamletFile "templates/Layout/header.hamlet")
    $(whamletFile "templates/TipoDoacao/tiposDoacao.hamlet")
    $(whamletFile "templates/Layout/footer.hamlet")

postApagarTipoR :: TipoDoacaoId -> Handler Html
postApagarTipoR cid = do
  runDB $ delete cid
  redirect ListaTipoR

getEditarTipoDoaR :: TipoDoacaoId -> Handler Html
getEditarTipoDoaR tdid = do
  tipoDoacao <- runDB $ get404 tdid
  (widget, _) <- generateFormPost (formTipoDoacao (Just tipoDoacao))
  msg <- getMessage
  usuario <- lookupSession "_ID"
  defaultLayout $ do
    addStylesheet (StaticR css_bootstrap_css)    
    addStylesheet (StaticR css_bootstrap_css)
    addStylesheet (StaticR css_estilo_css)
    $(whamletFile "templates/Layout/nav.hamlet")
    $(whamletFile "templates/Layout/header.hamlet")
    $(whamletFile "templates/TipoDoacao/tituloEditar.hamlet")
    (formWidget widget msg (EditarTipoDoaR tdid) "Editar")
    $(whamletFile "templates/Layout/footer.hamlet")

postEditarTipoDoaR :: TipoDoacaoId -> Handler Html
postEditarTipoDoaR tdid = do
  _ <- runDB $ get404 tdid
  ((result, _), _) <- runFormPost (formTipoDoacao Nothing)
  case result of
    FormSuccess novoTipoDoacao -> do
      runDB $ replace tdid novoTipoDoacao
      redirect ListaTipoR
    _ -> redirect HomeR
