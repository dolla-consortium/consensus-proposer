{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE NamedFieldPuns #-}
module Executables
  ( execute
  ) where

import           Prelude hiding (log)
import           Control.Monad.Reader

import           Streamly.Prelude as S
import qualified Streamly.Internal.Prelude as SIP

import           Dolla.Common.Logging.Core
import           Dolla.Common.Executable.Executable

import           Dolla.Consensus.Proposing.Staging.Execution.Environment.EventStore.Dolla.Pipeline (staging)
import           Dolla.Consensus.Proposing.Staging.Execution.Environment.EventStore.Settings
import           Dolla.Consensus.Proposing.Staging.Execution.Environment.EventStore.Dependencies
import           Dolla.Consensus.Proposing.Staging.Execution.Environment.EventStore.Dolla.Junction

execute :: IO ()
execute
  = executeMicroservice
      (\Settings {logger} -> logger)
      executePipeline
  where
    executePipeline :: ReaderT Dependencies IO ()
    executePipeline = do
      dependencies @ Dependencies {eventStoreClient,nodeId,logger} <- ask
      withReaderT (const (nodeId, eventStoreClient)) loadJunctionInEventStore
      log logger INFO "Pipeline Starting"
      drain $ SIP.runReaderT dependencies staging
      log logger INFO "End Of Pipeline"

