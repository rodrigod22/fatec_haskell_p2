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
  renderDivs $
    TipoDoacao
      <$> areq
        doubleField
        ( FieldSettings
            "Valor"
            Nothing
            (Just "n1")
            Nothing
            [("class", "form-control")]
        )
        (fmap tipoDoacaoValor mc)
      <*> areq
        textField
        ( FieldSettings
            "Beneficios"
            Nothing
            (Just "n2")
            Nothing
            [("class", "form-control")]
        )
        (fmap tipoDoacaoBeneficios mc)
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
  defaultLayout $ do
    usuario <- lookupSession "_ID"
    addStylesheet (StaticR css_bootstrap_css)
    addStylesheet (StaticR css_estilo_css)
    $(whamletFile "templates/Layout/header.hamlet")
    $(whamletFile "templates/TipoDoacao/tituloCadastro.hamlet")
    (formWidget widget msg TipoDoacaoR "Cadastrar")
    $(whamletFile "templates/Layout/footer.hamlet")

-- getTipoDoacaoR :: Handler Html
-- getTipoDoacaoR = do
--   tiposDoacao <- runDB $ selectList [] [Asc TipoDoacaoValor]
--   -- (widget, _) <- generateFormPost (formTipoDoacao Nothing)
--   msg <- getMessage
--   defaultLayout $ do
--     addStylesheet (StaticR css_bootstrap_css)
--     [whamlet|
--       $maybe mensa <- msg
--         <div>
--           ^{mensa}
--       <div class="container">
--         <h1>
--           Cadastro de Tipo de doação
--         <form method=post action=@{TipoDoacaoR} >
--           <div class="form-group">
--             <label for="valor">
--               Valor
--             <input type="text" class="form-control" id="valor" name="f1">
--             <div class="form-group">
--               <label for="beneficios">
--                 Beneficios
--               <input type="text" class="form-control" id="beneficios" name="f2">
--             <div class="form-group">
--               <label for="cupons">
--                 Quantidade de Cupons
--             <input type="text" class="form-control" id="cupons" name="f3">
--             <button type="submit" class="btn btn-primary mt-3">
--               Enviar solicitação
--     |]

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
  defaultLayout $ do
    usuario <- lookupSession "_ID"
    addStylesheet (StaticR css_bootstrap_css)
    addStylesheet (StaticR css_estilo_css)
    $(whamletFile "templates/Layout/header.hamlet")
    $(whamletFile "templates/TipoDoacao/perfil.hamlet")
    $(whamletFile "templates/Layout/footer.hamlet")

getListaTipoR :: Handler Html
getListaTipoR = do
  tiposDoacao <- runDB $ selectList [] [Asc TipoDoacaoValor]
  defaultLayout $ do
    usuario <- lookupSession "_ID"
    addStylesheet (StaticR css_bootstrap_css)
    addStylesheet (StaticR css_estilo_css)
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
  defaultLayout $ do
    addStylesheet (StaticR css_bootstrap_css)
    usuario <- lookupSession "_ID"
    addStylesheet (StaticR css_bootstrap_css)
    addStylesheet (StaticR css_estilo_css)
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
