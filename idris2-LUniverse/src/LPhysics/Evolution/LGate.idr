module LPhysics.Evolution.LGate

import LMath.Core
import Data.Linear.Ref1
import Data.Linear.Ref1.Swap

import Syntax.T1

%default total

||| A true Linear Gate acts on a physical spatial pointer in-place.
||| It consumes the F1 linear state token and returns it, mutating
||| the geometry without allocating a new universe state branch.
export
applyLinearMatterGate : LCell0 s -> ((Geometry, Amplitude) -> (Geometry, Amplitude)) -> F1 s ()
applyLinearMatterGate cell f = T1.do
  -- Read the old state (Geometry, Amplitude) linearly
  oldState <- read1 cell
  
  -- Compute the new state. Since Geometry/Amplitude aren't strictly linear types 
  -- themselves (they don't contain resources), we can just apply f.
  let newState = f oldState
  
  -- Write the new state, consuming the linear F1 context
  write1 cell newState
