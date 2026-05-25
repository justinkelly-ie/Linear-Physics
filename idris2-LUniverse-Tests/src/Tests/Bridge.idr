module Tests.Bridge

import QuickCheck
import Math.Core
import Math.Multiset
import LMath.Core
import LPhysics.Bridge
import LPhysics.Evolution.Cycle
import Data.Linear.Ref1
import Syntax.T1
import Data.List
import Tests.Common

%default covering

-- Helper to compare UniverseStates
eqUniverseState : Math.Core.UniverseState -> Math.Core.UniverseState -> Bool
eqUniverseState (MkUniverseState s1 v1) (MkUniverseState s2 v2) = (s1 == s2) && (v1 == v2)

-- The bridge identity test:
-- 1. Take a pure UniverseState
-- 2. Melt it into physical memory (allocates Ref1s)
-- 3. Freeze it back into a pure UniverseState
-- 4. They must be perfectly identical.
prop_melt_freeze_identity : Math.Core.UniverseState -> Bool
prop_melt_freeze_identity u =
  let result = run1 $ \t => 
        let lUniv # t1 := melt u t
            frozen # t2 := freeze lUniv t1
        in frozen # t2
  in eqUniverseState result u

export
tests : List Property
tests = [
  property "Bridge: Melt -> Freeze preserves state perfectly" prop_melt_freeze_identity
]
