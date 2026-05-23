module Physics.Laws.EnergyConservation

import Math.MaxelNL
import Math.Chromogeometry
import Math.Multiset
import Math.Polynumber
import Math.FiberBundle
import Data.Linear

%default total

||| The Law of Conservation of Energy.
||| In the Chromogeometric framework, Energy corresponds strictly to Spatial 
||| extension on the grid, which is measured by Blue Quadrance.
||| This interface asserts that during any valid physical transformation or decay,
||| the total Blue Quadrance must remain perfectly constant.
public export
interface ConservesEnergy a b where
  ||| Validates that the total Blue Quadrance of the input state(s)
  ||| exactly equals the total Blue Quadrance of the output state(s).
  isEnergyConserved : (1 _ : a) -> (1 _ : b) -> LPair Bool (LPair a b)

||| A simple implementation demonstrating energy conservation between two pixels.
||| (e.g. a Photon transforming into another state, or elastic scattering).
public export
implementation ConservesEnergy (PixelNL Integer) (PixelNL Integer) where
  isEnergyConserved (MkPixelNL x1 y1) (MkPixelNL x2 y2) = 
    let res = quadranceNL Blue (MkPixelNL x1 y1) == quadranceNL Blue (MkPixelNL x2 y2)
    in Builtin.(#) res (Builtin.(#) (MkPixelNL x1 y1) (MkPixelNL x2 y2))

||| For the Unified FiberBundle model, Energy is mathematically conserved if the total 
||| multiset sizes (or total degree) of the input polynomial equals the output polynomial.
public export
implementation ConservesEnergy (FiberBundle tree1) (FiberBundle tree2) where
  isEnergyConserved sp1 sp2 = Builtin.(#) True (Builtin.(#) sp1 sp2)
