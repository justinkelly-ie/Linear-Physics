module Math.Topology.Boundary

import Math.MaxelNL
import Math.Multiset
import Math.Topology.Simplex
import Math.Topology.Chain

%default total

-----------------------------------------------------------------------
-- THE ALGEBRAIC BOUNDARY OPERATOR (∂)
-----------------------------------------------------------------------

||| The boundary operator for a 1-Simplex (directed edge).
||| In algebraic topology, ∂(A -> B) = B - A.
||| This formal coordinate difference is the generator for all Chromogeometric metric properties.
public export
boundary1Cell : Cell1 -> Cell0
boundary1Cell (MkPixelNL xA yA, MkPixelNL xB yB) = MkPixelNL (xB - xA) (yB - yA)

||| The boundary operator for a 2-Simplex (face/triangle).
||| ∂(A, B, C) = (B -> C) - (A -> C) + (A -> B)
||| Maps a triangle down to its 1-Chain perimeter.
public export
boundary2Cell : Cell2 -> Chain1
boundary2Cell (a, b, c) = 
  -- Simplified representation: multiset of the perimeter edges
  fromList [ ((a, b), 1)
           , ((b, c), 1)
           , ((c, a), 1)
           ]
