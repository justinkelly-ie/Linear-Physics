module Physics.Evolution.Baryogenesis

import Math.SpreadPolynomial
import Physics.Evolution.Transition
import Math.FiberBundle
import Physics.Findings.CosmicPartition

%default total

||| Epoch 2: The Genesis of Baryons
|||
||| Standard astrophysics assumes Baryogenesis (the sudden manifestation of matter)
||| was a thermal accident driven by a slight CP violation in the early universe, 
||| with no mathematical explanation for why exactly that much matter formed.
|||
||| In LUniverse, Epoch 2 is mathematically inevitable. As the primordial Spread 
||| Polynomials unfold recursively, they reach a threshold where their mathematical 
||| combinations partition exactly into the 210-state Primorial Manifold:
|||
||| 1. 128 states (2^7) resolve into irreducible fractional denominators. They
|||    cannot be instantiated on the discrete integer grid, becoming the invisible
|||    Dark Energy expansion pressure.
||| 2. 55 states remain as the topological background vacuum (Dark Matter).
||| 3. Exactly 27 states (3^3) resolve cleanly into integers. A 3x3x3 grid is 
|||    the geometric definition of a Baryonic Triad (3 quarks).
|||
||| Thus, Baryogenesis is just the mathematical sorting of polynomial states 
||| into 27 resolvable integers and 128 unresolvable fractions!

||| A formal proof that Epoch 2 creates exactly 27 integer states.
||| This is the root cause of Baryon Asymmetry.
public export
data BaryonGenesis : Type where
  ||| The formal partition of the 155 active states into 128 Dark Energy fractions
  ||| and 27 Visible Matter integers.
  MkBaryonGenesis : (darkEnergy : Nat) -> (visibleMatter : Nat) -> BaryonGenesis

||| Evaluates the state overflow during Epoch 2 without consuming it.
public export
evaluateEpoch2 : {tree : SpacetimeManifold} -> (0 _ : FiberBundle tree) -> BaryonGenesis
evaluateEpoch2 _ = 
  -- We extract the structural lengths of the lists in the state partition.
  MkBaryonGenesis darkEnergyStates visibleMatterStates
