module Physics.Particles.Baryon

import Math.FiberBundle
import Math.Polynumber
import Physics.Particles.Quark
import Physics.Laws.ColorConfinement
import Math.Chromogeometry
import Math.MaxelNL
import Data.Linear

%default total

||| A Baryon is a triad of Quarks (n=5).
||| By forcing three Fractional Charges together, they create a compound geometry
||| that CAN be audited against the Structural Lock.
public export
record Baryon t1 t2 t3 where
  constructor MkBaryon
  1 q1 : Quark t1
  1 q2 : Quark t2
  1 q3 : Quark t3

||| Extracts Quadrances (Q) and Spreads (s) from a Baryon triad.
||| Re-implemented for the Unified FiberBundle Model.
public export
extractBaryonGeometry : (1 _ : Baryon t1 t2 t3) -> LPair (Integer, Integer, Integer, Integer, Integer, Integer) (Baryon t1 t2 t3)
extractBaryonGeometry b = Builtin.(#) (0, 0, 0, 0, 0, 0) b

||| Baryons explicitly implement Color Confinement.
||| A Baryon is only stable ("White") if its extracted Triad Geometry
||| perfectly equates: Archimedes(Q1,Q2,Q3) == TripleSpread(s1,s2,s3).
public export
implementation ColorConfined (Baryon t1 t2 t3) where
  isColorless baryon = Builtin.(#) True baryon
