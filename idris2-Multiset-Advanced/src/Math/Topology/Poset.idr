module Math.Topology.Poset

%default total

||| A pure mathematical Partially Ordered Set (Poset) structured as a Directed Acyclic Graph.
||| In Algebraic Topology, this serves as the discrete Base Space for Sheaves.
public export
data Poset : (meta : Type) -> Type where
  ||| The absolute root of the Poset.
  Root : (label : String) -> (metadata : meta) -> Poset meta
  
  ||| A nested node in the Poset with strict directed edges to a parent and substrate.
  Node : (label : String) -> (parent : Poset meta) -> (substrate : Poset meta) -> (metadata : meta) -> Poset meta

||| Extracts the label from the Poset node.
public export
getLabel : Poset meta -> String
getLabel (Root label _) = label
getLabel (Node label _ _ _) = label

||| Extracts the metadata (e.g. geometric constraints) from the Poset node.
public export
getMeta : Poset meta -> meta
getMeta (Root _ m) = m
getMeta (Node _ _ _ m) = m

||| Calculates the topological depth of the Poset node.
public export
getDepth : Poset meta -> Nat
getDepth (Root _ _) = 0
getDepth (Node _ parent _ _) = 1 + getDepth parent
