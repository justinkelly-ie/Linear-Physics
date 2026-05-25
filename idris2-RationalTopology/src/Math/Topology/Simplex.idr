module Math.Topology.Simplex

import Math.MaxelNL

%default total

-----------------------------------------------------------------------
-- SIMPLICES (The basic building blocks of space)
-----------------------------------------------------------------------

||| A 0-Simplex (0-Cell) is a naked coordinate point (vertex) in space.
||| Represented by a raw PixelNL coordinate.
public export
Cell0 : Type
Cell0 = PixelNL Integer

||| A 1-Simplex (1-Cell) is a directed edge connecting two 0-Cells.
||| It represents causal flow or connectivity.
public export
Cell1 : Type
Cell1 = (Cell0, Cell0)

||| A 2-Simplex (2-Cell) is a face/triangle defined by three 0-Cells.
||| This is the domain where metric curvature (Spread/Archimedes) is evaluated.
public export
Cell2 : Type
Cell2 = (Cell0, Cell0, Cell0)
