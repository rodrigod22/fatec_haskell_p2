{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE ViewPatterns #-}
{-# LANGUAGE NoImplicitPrelude #-}

module Foundation where

import Database.Persist.Sql (ConnectionPool, runSqlPool)
import Import.NoFoundation
import Yesod.Core.Types (Logger)

data App = App
  { appSettings :: AppSettings,
    appStatic :: Static,
    appConnPool :: ConnectionPool,
    appHttpManager :: Manager,
    appLogger :: Logger
  }

mkYesodData "App" $(parseRoutesFile "config/routes")

type Form a = Html -> MForm Handler (FormResult a, Widget)

instance Yesod App where
  makeLogger = return . appLogger

  authRoute _ = Just AutR

  isAuthorized HomeR _ = return Authorized
  isAuthorized (StaticR _) _ = return Authorized
  isAuthorized CrossR _ = return Authorized
  isAuthorized FotoR _ = return Authorized
  isAuthorized DoacaoR _ = return Authorized
  isAuthorized AutR _ = return Authorized
  isAuthorized UsuarioR _ = return Authorized
  isAuthorized AdminR _ = isAdmin
  isAuthorized _ _ = isUsuario

isAdmin :: Handler AuthResult
isAdmin = do
  sess <- lookupSession "_ID"
  case sess of
    Nothing -> return AuthenticationRequired
    Just "admin" -> return Authorized
    Just _ -> return (Unauthorized "Usuario não autorizado")

isUsuario :: Handler AuthResult
isUsuario = do
  sess <- lookupSession "_ID"
  case sess of
    Nothing -> return AuthenticationRequired
    Just _ -> return Authorized

instance YesodPersist App where
  type YesodPersistBackend App = SqlBackend
  runDB action = do
    master <- getYesod
    runSqlPool action $ appConnPool master

instance RenderMessage App FormMessage where
  renderMessage _ _ = defaultFormMessage

instance HasHttpManager App where
  getHttpManager = appHttpManager
