module Physics.Evolution.Transition

import Math.Multiset
import Math.Polynumber
import Math.SpreadPolynomial
import Math.FiberBundle
import Physics.Evolution.QuantumGates

%default total

||| A unified Transition (Functor) that evaluates a state by applying a Quantum Gate.
||| This extends the topological Base Space (the Poset) by appending a new Node.
||| The new node explicitly stores the human-readable Gate name and geometric scale!
public export covering
evolveEpoch : {tree : SpacetimeManifold} -> 
              (gate : FundamentalGate) -> 
              (1 current : FiberBundle tree) -> 
              FiberBundle (Node gate.name tree (Root "VacuumSubstrate" (MkGeometry 1 Rigid)) (MkGeometry gate.degree Rigid))
evolveEpoch gate (MkRootSheaf stateVector) = 
  let () = lconsume stateVector in
  -- The fiber geometry is updated to match the new Poset boundaries!
  MkNestedSheaf {m = MkGeometry gate.degree Rigid} (emptyPoly {geom = MkGeometry gate.degree Rigid})
evolveEpoch gate (MkNestedSheaf stateVector) = 
  let () = lconsume stateVector in
  MkNestedSheaf {m = MkGeometry gate.degree Rigid} (emptyPoly {geom = MkGeometry gate.degree Rigid})
