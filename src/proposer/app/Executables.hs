{-# LANGUAGE DuplicateRecordFields #-}
module Executables
  ( proposer
  ) where


import qualified Dolla.Consensus.Proposer.BucketizerOverEventStore as Proposer

proposer :: IO ()
proposer = Proposer.execute

