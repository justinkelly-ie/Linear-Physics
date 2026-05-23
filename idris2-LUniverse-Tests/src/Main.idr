module Main

import QuickCheck
import Tests.Common
import Tests.LabelExtraction
import Tests.DimensionalCausality
import Tests.EpochInjection
import Tests.CosmologicalScaling

%default total

main : IO ()
main = do
  putStrLn "Starting Spacetime QuickCheck Suite...\n"
  
  putStrLn "Test 1: General label extraction from randomly unfolded Spacetimes"
  let res1 = quickCheck prop_spacetimeHasLabel
  putStrLn (msg res1)
  
  putStrLn "Test 2: Proving Strict Causality (No non-prime/invalid dimensions in any timeline history)"
  let res2 = quickCheck prop_strictCausality
  putStrLn (msg res2)
  
  putStrLn "Test 3: Injecting Baryogenesis Epoch (Starting at n=3) and running 100 simulations"
  -- We test from the injected Baryogenesis state using our new QuickCheck feature!
  let res3 = quickCheckFrom baryogenesisEpoch prop_strictCausality
  putStrLn (msg res3)

  putStrLn "Test 4: Cosmological Scaling (Proving the Eddington Limit structural bounds)"
  let res4 = quickCheck prop_eddingtonScaling
  putStrLn (msg res4)

  putStrLn "Test 5: Negative Testing (Proving the universe scale strictly breaks if 138 is used)"
  let res5 = quickCheck prop_not138
  putStrLn (msg res5)
