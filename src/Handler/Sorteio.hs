{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE NoImplicitPrelude #-}

module Handler.Sorteio where

import Handler.Auxiliar
import Import

formSorteio :: Maybe Sorteio -> Form Sorteio
formSorteio mc =
  renderDivs $ Sorteio     
      <$> areq
        textField  
        ( FieldSettings
            "Dia"
            Nothing
            (Just "data")
            Nothing
            [("class", "form-control")]
        )
        (fmap sorteioData mc)
      <*> areq
        textField 
        ( FieldSettings
            "Premio"
            Nothing
            (Just "n2")
            Nothing
            [("class", "form-control")]
        )
        (fmap sorteioPremio mc)

getSorteioR :: Handler Html
getSorteioR = do
  (widget, _) <- generateFormPost (formSorteio Nothing)
  msg <- getMessage
  defaultLayout $ do
    usuario <- lookupSession "_ID"
    addStylesheet (StaticR css_bootstrap_css)
    addStylesheet (StaticR css_estilo_css)   
    $(whamletFile "templates/Layout/nav.hamlet")
    $(whamletFile "templates/Layout/header.hamlet")    
    $(whamletFile "templates/Sorteio/tituloCadastro.hamlet")
    (formWidget widget msg SorteioR "Cadastrar")
    $(whamletFile "templates/Layout/footer.hamlet")

postSorteioR :: Handler Html
postSorteioR = do
  ((result, _), _) <- runFormPost (formSorteio Nothing)
  case result of
    FormSuccess sorteio -> do
      runDB $ insert sorteio
      setMessage
        [shamlet|
        <div>
          Tipo incluido com sucesso !
      |]
      redirect SorteioR
    _ -> redirect HomeR

getListaSorteioR :: Handler Html
getListaSorteioR = do
  sorteios <- runDB $ selectList [] [Asc SorteioPremio  ]
  usuario <- lookupSession "_ID"
  defaultLayout $ do    
    addStylesheet (StaticR css_bootstrap_css)
    addStylesheet (StaticR css_estilo_css)
    $(whamletFile "templates/Layout/nav.hamlet")
    $(whamletFile "templates/Layout/header.hamlet")
    $(whamletFile "templates/Sorteio/sorteios.hamlet")
    $(whamletFile "templates/Layout/footer.hamlet")

postApagarSorteioR :: SorteioId -> Handler Html
postApagarSorteioR cid = do
  runDB $ delete cid
  redirect ListaTipoR

getEditarSorteioR :: SorteioId -> Handler Html
getEditarSorteioR sid = do
  sorteio <- runDB $ get404 sid
  (widget, _) <- generateFormPost (formSorteio (Just sorteio))
  msg <- getMessage
  defaultLayout $ do
    addStylesheet (StaticR css_bootstrap_css)
    usuario <- lookupSession "_ID"
    addStylesheet (StaticR css_bootstrap_css)
    addStylesheet (StaticR css_estilo_css)
    $(whamletFile "templates/Layout/nav.hamlet")
    $(whamletFile "templates/Layout/header.hamlet")
    $(whamletFile "templates/Sorteio/tituloEditar.hamlet")
    (formWidget widget msg (EditarSorteioR sid) "Editar")
    $(whamletFile "templates/Layout/footer.hamlet")

postEditarSorteioR :: SorteioId -> Handler Html
postEditarSorteioR sid = do
  _ <- runDB $ get404 sid
  ((result, _), _) <- runFormPost (formSorteio Nothing)
  case result of
    FormSuccess novoSorteio -> do
      runDB $ replace sid novoSorteio
      redirect ListaSorteioR
    _ -> redirect HomeR
