module Math.Topology.Chain

import Math.Multiset
import Math.Topology.Simplex

%default total

-----------------------------------------------------------------------
-- SIMPLICIAL CHAINS (Formal combinations of simplices)
-----------------------------------------------------------------------

||| A 0-Chain is a formal multiset of vertices (0-Cells).
||| Without directed edges, a 0-Chain is static "dust" and possesses no time.
public export
Chain0 : Type
Chain0 = Multiset Cell0

||| A 1-Chain is a formal multiset of directed edges (1-Cells).
||| In Rational Topology, the presence of a 1-Chain is the strict prerequisite
||| for causal history and Relational Time. This is the true identity of a Substrate.
public export
Chain1 : Type
Chain1 = Multiset Cell1

||| A 2-Chain is a formal multiset of triangles (2-Cells).
||| Fields naturally exist over 2-Chains because physical spread evaluation
||| intrinsically demands triads to compute cross-curvature.
public export
Chain2 : Type
Chain2 = Multiset Cell2
