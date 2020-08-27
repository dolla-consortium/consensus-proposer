{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE NamedFieldPuns #-}
module Dolla.Consensus.Proposing.Zeus.Local.MicroserviceSettings.Requesting.Simulating
  ( MicroserviceSettings (..))
  where

import           Prelude hiding (FilePath,writeFile)

import           Data.Aeson (encode)

import           Dolla.Common.NodeId (NodeId)
import           Dolla.Common.Logging.Core
import           Dolla.Common.Network.Core (URL)

import           Dolla.Consensus.Common.Zeus.Logging
import           Dolla.Consensus.Common.Zeus.Haskell.ExecutableSettings

import           Dolla.Consensus.Proposing.Client.Simulator.Settings

import qualified Dolla.Consensus.Proposing.Receptioning.API.Client.Settings as Receptionist.Client


data MicroserviceSettings
  = MicroserviceSettings
  { nodeId :: NodeId
  , executableName :: String
  , logFileLocation :: FileSystemLocation
  , configurationLocation :: FileSystemLocation
  , receptioningUrl :: URL}

instance ExecutableSettingsProvider MicroserviceSettings  where
  getExecutableSettings clientSimulatorSettings @ MicroserviceSettings {executableName,logFileLocation,configurationLocation} =
    ExecutableSettings
    { executableName
    , executableSettings = encode $ getExecutableConfiguration clientSimulatorSettings
    , logFileLocation
    , configurationLocation}


getExecutableConfiguration :: MicroserviceSettings -> Settings
getExecutableConfiguration MicroserviceSettings {..}
  = Settings
    { logger = LoggerSettings { priority = INFO , loggerId = LoggerId "[requesting.simulating]"}
    , receptioningClient
        = Receptionist.Client.Settings
          { logger = nodeLoggerId nodeId INFO  "receptioning.client"
          , nodeId
          , url = receptioningUrl }}
