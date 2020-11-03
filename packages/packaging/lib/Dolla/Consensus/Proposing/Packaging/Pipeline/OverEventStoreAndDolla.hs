{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE FlexibleContexts #-}
module Dolla.Consensus.Proposing.Packaging.Pipeline.OverEventStoreAndDolla (packaging) where

import           Prelude hiding (log)
import           Control.Monad.Reader
import           Control.Monad.Catch (MonadCatch)

import           Data.Data

import qualified Streamly as S

import qualified Dolla.Consensus.Proposing.Packaging.Pipeline.OverEventStore as OverEventStore
import           Dolla.Consensus.Proposing.Packaging.Dependencies

import           Dolla.Consensus.Request
import           Dolla.Consensus.Dummy.Client.Request
import           Dolla.Consensus.Consortium.Request

packaging
  :: ( MonadReader Dependencies m
     , S.MonadAsync m
     , MonadCatch m)
  => S.SerialT m ()
packaging 
  = OverEventStore.packaging (Proxy :: Proxy (Request DollaClientRequest ConsortiumRequest))


