module Main

import Universe.CosmicPartition
import Physics.QuantumGates
import Physics.Findings.PeriodicTable
import Data.Fin

gridLimitVal : Double
gridLimitVal = case Feynmanium of
                 MkElement z => cast (finToNat z)

main : IO ()
main = do
  let de = length constructPrimorialGrid.darkEnergy
  let tot = primorialManifold
  putStrLn $ show de ++ " / " ++ show tot
  putStrLn $ "Grid Limit: " ++ show gridLimitVal

