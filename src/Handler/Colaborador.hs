{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE NoImplicitPrelude #-}

module Handler.Colaborador where
import Database.Persist.Postgresql

import Handler.Auxiliar
import Import

formColaborador :: Form Colaborador
formColaborador =
  renderDivs $
    Colaborador
      <$> areq textField  ( FieldSettings
                              "Nome"
                              Nothing
                              (Just "n1")
                              Nothing
                              [("class", "form-control")]
                          ) Nothing
      <*> areq textField ( FieldSettings
                              "Email"
                              Nothing
                              (Just "n2")
                              Nothing
                              [("class", "form-control")]
                          ) Nothing
      <*> areq textField ( FieldSettings
                              "Telefone"
                              Nothing
                              (Just "n3")
                              Nothing
                              [("class", "form-control")]
                          ) Nothing 
      <*> areq (selectField tipoCB) ( FieldSettings
                              "Tipo Doação"
                              Nothing
                              (Just "n4")
                              Nothing
                              [("class", "form-control")]
                          ) Nothing  

tipoCB = do 
  tipos <- runDB $ selectList [] [Asc TipoDoacaoDescricao]      
  optionsPairs $
    map(\r -> (tipoDoacaoDescricao $ entityVal  r, entityKey r)) tipos

getColaboradorR :: Handler Html
getColaboradorR = do
  (widget, _) <- generateFormPost formColaborador
  msg <- getMessage
  usuario <- lookupSession "_ID"
  defaultLayout $ do  
    addStylesheet (StaticR css_bootstrap_css)
    addStylesheet (StaticR css_estilo_css)
    $(whamletFile "templates/Layout/nav.hamlet")  
    $(whamletFile "templates/Layout/header.hamlet")  
    $(whamletFile "templates/Colaborador/titulo.hamlet") 
    (formWidget widget msg ColaboradorR "Cadastrar")
    $(whamletFile "templates/Layout/footer.hamlet")


postColaboradorR :: Handler Html 
postColaboradorR = do
  ((result, _), _) <- runFormPost formColaborador
  case result of
    FormSuccess (colaborador@(Colaborador nome email telefone tipoDoacaoId)) -> do

      runDB $ insert colaborador
      setMessage
        [shamlet|
          <div>
            Colaboradoração cadastrada com sucesso !!!
      |]
      redirect ListaColabR  
  
    _ -> redirect HomeR

getListaColabR :: Handler Html
getListaColabR = do
  let sql = "SELECT ??, ?? FROM colaborador  \ 
      \ INNER JOIN tipo_doacao ON tipo_doacao.id = colaborador.tipo_doacao_id "
  colaboradores <- runDB $ rawSql sql [] :: Handler [(Entity Colaborador,
   Entity TipoDoacao)]  
 -- colaboradores <- runDB $ selectList [] [Asc ColaboradorNome]
  usuario <- lookupSession "_ID"
  defaultLayout $ do
    addStylesheet (StaticR css_bootstrap_css)
    addStylesheet (StaticR css_estilo_css)
    $(whamletFile "templates/Layout/nav.hamlet")
    $(whamletFile "templates/Layout/header.hamlet")      
    $(whamletFile "templates/Colaborador/colaboradores.hamlet")
    $(whamletFile "templates/Layout/footer.hamlet")

