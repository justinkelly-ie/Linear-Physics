module Main

import Universe.DarkPlusMatter
import Universe.CosmicPartition
import Physics.QuantumGates
import Physics.Findings.PeriodicTable
import Data.Fin

testDeRatio : Double
testDeRatio =
  let deStates = cast (length constructPrimorialGrid.darkEnergy)
      totalStates = cast primorialManifold
  in deStates / totalStates

testGridLimit : Double
testGridLimit =
  case Feynmanium of
    MkElement z => cast (finToNat z)

