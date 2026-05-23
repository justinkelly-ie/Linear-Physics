module Math.Topology.Sheaf

import Math.Topology.Poset

%default total

||| A Combinatorial Sheaf (or Fiber Bundle) over a Poset Base Space.
||| This maps algebraic data (the Fiber) strictly into the boundaries of a topological Poset.
||| The fiber type mathematically depends on the metadata of the topological node it binds to.
public export
data Sheaf : (base : Poset meta) -> (fiber : meta -> Type) -> Type where
  MkRootSheaf   : {m : meta} -> {label : String} -> (1 dataVec : fiber m) -> Sheaf (Root label m) fiber
  MkNestedSheaf : {m : meta} -> {label : String} -> {p, s : Poset meta} -> (1 dataVec : fiber m) -> Sheaf (Node label p s m) fiber
