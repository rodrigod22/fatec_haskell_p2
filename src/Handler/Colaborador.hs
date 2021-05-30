{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE NoImplicitPrelude #-}

module Handler.Colaborador where

import Import

formColaborador :: Form Colaborador
formColaborador =
  renderDivs $
    Colaborador
      <$> areq textField "Nome: " Nothing
      <*> areq textField "Email: " Nothing
      <*> areq textField "Telefone: " Nothing

getColaboradorR :: Handler Html
getColaboradorR = do
  (widget, _) <- generateFormPost formColaborador
  msg <- getMessage
  defaultLayout $
    [whamlet|
      $maybe mensa <- msg
        <div>
          ^{mensa}
      <h1>
        Cadastro de Colaborador

      <form method=post action=@{ColaboradorR} >
        ^{widget}
        <input type="submit" value="Cadastrar">      
    |]

-- getColaboradorR :: Handler Html
-- getColaboradorR = do
--   (widget, _) <- generateFormPost formColaborador
--   msg <- getMessage
--   defaultLayout $
--     [whamlet|
--       $maybe mensa <- msg
--         <div>
--           ^{mensa}
--       <h1>
--         Cadastro de Colaborador

--       <form method=post action=@{ColaboradorR} >
--         ^{widget}
--         <input type="submit" value="Cadastrar">
--     |]

postColaboradorR :: Handler Html
postColaboradorR = do
  ((result, _), _) <- runFormPost formColaborador
  case result of
    FormSuccess colaborador -> do
      runDB $ insert colaborador
      setMessage
        [shamlet|

        <div>
          Cliente incluido com sucesso !
      |]
      redirect ColaboradorR
    _ -> redirect HomeR

getPerfilR :: ColaboradorId -> Handler Html
getPerfilR cid = do
  colaborador <- runDB $ get404 cid
  defaultLayout $ do
    addStylesheet (StaticR css_bootstrap_css)
    addStylesheet (StaticR css_estilo_css)
    -- $(whamletFile "templates/Layout/header.hamlet")

    $(whamletFile "templates/Colaborador/perfil.hamlet")

getListaColabR :: Handler Html
getListaColabR = do
  colaboradores <- runDB $ selectList [] [Asc ColaboradorNome]
  defaultLayout $ do
    addStylesheet (StaticR css_bootstrap_css)
    addStylesheet (StaticR css_estilo_css)
    -- $(whamletFile "templates/Layout/header.hamlet")
    $(whamletFile "templates/Colaborador/colaboradores.hamlet")
    $(whamletFile "templates/Layout/footer.hamlet")

postApagarColabR :: ColaboradorId -> Handler Html
postApagarColabR cid = do
  runDB $ delete cid
  redirect ListaColabR
