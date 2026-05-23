module Math.FiberBundle

import Math.Multiset
import public Math.Polynumber
import Math.Interfaces
import public Math.Topology.Poset
import public Math.Topology.Sheaf
import Math.DenseAMSet
import Math.IntPolynumber
import Math.MaxelNL
import Math.SpreadPolynomial
import Math.Chromogeometry

%default total

-----------------------------------------------------------------------
-- 1. GEOMETRY IMPORTS
-----------------------------------------------------------------------

-- Flexibility and Geometry are now inherently part of the pure Polynumber math
-- package (idris2-Multiset-Advanced), so we just import them natively here!

-----------------------------------------------------------------------
-- 2. SPACETIME MANIFOLD (The Base Space / Topological Poset)
-----------------------------------------------------------------------

||| The cosmological fractal hierarchy of physical contexts and substrates.
||| Modeled precisely as a Partially Ordered Set (Poset / DAG) from Algebraic Topology.
|||
||| Also known in the literature as:
|||   - `PhaseTree`       — original LUniverse internal name
|||   - `Poset`           — Wildberger / Algebraic Topology (pure math layer)
|||   - `CausalGraph`     — Loop Quantum Gravity terminology
|||   - `SpinFoam`        — Penrose / Spinor network terminology
|||   - `Substrate`       — General Relativity / Field Theory background
public export
SpacetimeManifold : Type
SpacetimeManifold = Poset Geometry

-----------------------------------------------------------------------
-- 3. FIBER BUNDLE (The Physics State Space)
-----------------------------------------------------------------------

||| A FiberBundle binds the quantum state algebra (the Fiber) strictly inside the
||| topological boundaries of the physical context (the Base Space / SpacetimeManifold).
||| The evaluation of this multiset fiber *is* the physics.
|||
||| Also known in the literature as:
|||   - `StatePhase`      — original LUniverse internal name
|||   - `Sheaf`           — Wildberger / Algebraic Topology (pure math layer)
|||   - `FockSpace`       — Quantum Field Theory (particle number representation)
|||   - `GaugeField`      — Yang-Mills / Standard Model terminology
|||   - `WaveFunction`    — Copenhagen / Schrödinger formulation
public export
0 FiberBundle : SpacetimeManifold -> Type
FiberBundle tree = Sheaf tree Polynumber

-----------------------------------------------------------------------
-- 4. OBSERVABILITY & EXTRACTION
-----------------------------------------------------------------------

-- Observability methods like `getLabel` and `getDepth` are now inherited directly
-- from `Math.Topology.Poset` as pure mathematical operations.

||| Extracts the geometric constraint of the current phase.
public export
getGeometry : SpacetimeManifold -> Geometry
getGeometry tree = getMeta tree

-----------------------------------------------------------------------
-- 5. MULTISET ALGEBRA INTERFACES
-----------------------------------------------------------------------

||| Enables safe QTT linear erasure of a phase by delegating to the multiset.
public export
implementation LConsumable (FiberBundle tree) where
  lconsume (MkRootSheaf stateVector) = lconsume stateVector
  lconsume (MkNestedSheaf stateVector) = lconsume stateVector

||| Enables additive superposition of two phases operating in the same context.
public export
implementation Semigroup (FiberBundle tree) where
  (MkRootSheaf s1) <+> (MkRootSheaf s2) = MkRootSheaf (s1 <+> s2)
  (MkNestedSheaf s1) <+> (MkNestedSheaf s2) = MkNestedSheaf (s1 <+> s2)

-----------------------------------------------------------------------
-- 6. DARK PLUS MATTER (Concrete Cosmological State Vector)
-----------------------------------------------------------------------

||| The Chromogeometric Configuration of a DarkPlusMatter State.
||| Maps directly to the three forms: Matter (Blue), Dark Energy (Red), Background (Green).
||| This replaces the legacy Möbius parity (1/-1) tracking.
public export
data Flavor = Matter | DarkEnergy | Background

||| Determines the Chromogeometric Metric corresponding to a Flavor.
public export
flavorMetric : Flavor -> Metric
flavorMetric Matter     = Blue
flavorMetric DarkEnergy = Red
flavorMetric Background = Green

||| DarkPlusMatter acts as the unprojected coordinate engine and
||| cosmological state vector for the 137-Grid.
||| It unifies Matter and Dark Energy using Norman Wildberger's
||| Spread Polynomials and the underlying Maxel Support.
|||
||| This is a physics-domain record built on top of FiberBundle algebra.
||| It is NOT a replacement for FiberBundle — it is a concrete cosmic state vector
||| carrying the four physical quantities needed by the Findings and Evolution modules.
public export
record DarkPlusMatter where
  constructor MkDarkPlusMatter
  ||| The current generation number (N) of the Universe unfolding.
  generation   : Nat
  ||| The current generation encoded as a Spread Polynomial (replaces legacy Möbius engine).
  statePoly    : IntPolynumber
  ||| The underlying lattice topology (Support of the Maxel) embedding the 128+27 states.
  maxelSupport : DenseAMSet (PixelNL Integer)
  ||| The current unified Flavor configuration.
  flavor       : Flavor

||| Creates a foundational, unexcited (Background) DarkPlusMatter state.
public export
primordialDarkPlusMatter : DenseAMSet (PixelNL Integer) -> DarkPlusMatter
primordialDarkPlusMatter supp = MkDarkPlusMatter Z emptyIntPoly supp Background

||| Progresses the DarkPlusMatter state to the N-th spread polynomial.
||| Simulates cosmological scaling / unfolding over N generations.
public export covering
unfoldState : Nat -> DarkPlusMatter -> DarkPlusMatter
unfoldState n (MkDarkPlusMatter _ _ supp f) = MkDarkPlusMatter n (spreadPoly n) supp f

||| Pivots the Flavor configuration (analogous to shifting the active Chromogeometric Metric).
public export
pivotFlavor : Flavor -> DarkPlusMatter -> DarkPlusMatter
pivotFlavor newF (MkDarkPlusMatter gen p supp _) = MkDarkPlusMatter gen p supp newF

||| Extracts the primary topological pixel from a DarkPlusMatter state.
||| Defaults to origin (0,0) if the particle is delocalized (empty vacuum).
public export
extractPixel : DarkPlusMatter -> PixelNL Integer
extractPixel state =
  case state.maxelSupport.items of
    []            => MkPixelNL 0 0
    ((p, _) :: _) => p

