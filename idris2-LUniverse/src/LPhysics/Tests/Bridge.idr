module LPhysics.Tests.Bridge

import LMath.Core
import Math.Multiset
import LPhysics.Bridge
import LPhysics.Evolution.Cycle
import LPhysics.Evolution.Init
import Data.Linear.Ref1
import Syntax.T1
import Data.List

%default covering

-- Helper to compare UniverseStates
eqUniverseState : LMath.Core.UniverseState -> LMath.Core.UniverseState -> Bool
eqUniverseState (MkUniverseState s1 v1) (MkUniverseState s2 v2) = (s1 == s2) && (v1 == v2)

-- The bridge identity test:
-- 1. Take a pure UniverseState
-- 2. Melt it into physical memory (allocates Ref1s)
-- 3. Freeze it back into a pure UniverseState
-- 4. They must be perfectly identical.
export
runBridgeTest : IO ()
runBridgeTest = do
  putStrLn "Running Bridge Identity Test (Melt -> Freeze)..."
  -- Create a vacuum universe state
  let u = LPhysics.Evolution.Init.seedChromogeometricVacuum 137
  let result = run1 $ \t => 
        let lUniv # t1 := melt u t
            frozen # t2 := freeze lUniv t1
        in frozen # t2
  if eqUniverseState result u
     then putStrLn "✅ SUCCESS: Bridge Identity Preserved."
     else putStrLn "❌ FAILED: Bridge Identity Broken!"

