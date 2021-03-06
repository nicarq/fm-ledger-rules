{-# LANGUAGE TemplateHaskell #-}

module PParams
  ( PParams(..)
    -- lenses
  , minfeeA
  , minfeeB
  , keyDeposit
  , poolDeposit
  , minRefund
  , decayRate
  , movingAvgWeight
  , eMax
  , movingAvgExp
  , poolConsts
  , poolMinRefund
  , poolDecayRate
  , rho
  , tau
  , UnitInterval
  , mkUnitInterval
  , intervalValue
  , interval0
  , interval1
  , emptyPParams
  ) where

import           Numeric.Natural (Natural)

import           Coin            (Coin (..))
import           Slot            (Epoch(..))

import           Lens.Micro.TH   (makeLenses)

-- | Type to represent a value in the unit interval [0; 1]
newtype UnitInterval = UnitInterval Rational
    deriving(Show, Ord, Eq)

-- | Return a `UnitInterval` type if `r` is in [0; 1].
mkUnitInterval :: Rational -> Maybe UnitInterval
mkUnitInterval r = if r <= 1 && r >= 0 then Just $ UnitInterval r else Nothing

-- | Get rational value of `UnitInterval` type
intervalValue :: UnitInterval -> Rational
intervalValue (UnitInterval v) = v

interval0 :: UnitInterval
interval0 = UnitInterval 0

interval1 :: UnitInterval
interval1 = UnitInterval 1

data PParams = PParams
  { -- |The linear factor for the minimum fee calculation
    _minfeeA         :: Natural
    -- |The constant factor for the minimum fee calculation
  , _minfeeB         :: Natural
    -- |The amount of a key registration deposit
  , _keyDeposit      :: Coin
    -- |The amount of a pool registration deposit
  , _poolDeposit     :: Coin
    -- |The minimum percent refund guarantee
  , _minRefund       :: UnitInterval
    -- |The deposit decay rate
  , _decayRate       :: Rational
    -- |Moving average weight.
  , _movingAvgWeight :: UnitInterval
    -- |Moving average exponent.
  , _movingAvgExp    :: Rational
    -- | epoch bound on pool retirement
  , _eMax            :: Epoch
    -- |Pool constants
  , _poolConsts      :: (Rational, Natural)
    -- | The minimum percent pool refund
  , _poolMinRefund   :: UnitInterval
    -- | Decay rate for pool deposits
  , _poolDecayRate   :: Rational
    -- | Account transition parameter
  , _rho             :: UnitInterval
  , _tau             :: UnitInterval
  } deriving (Show, Eq)

makeLenses ''PParams

-- | Returns a basic "empty" `PParams` structure with all zero values.
emptyPParams :: PParams
emptyPParams =
    PParams 0 0 (Coin 0) (Coin 0) interval0 0 interval0 0 (Epoch 0) (0, 0) interval0 0 interval0 interval0
