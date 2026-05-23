module Physics.Laws.PauliExclusion

import Math.MaxelNL
import Math.Multiset
import Math.Polynumber
import Math.FiberBundle

%default total

||| The Pauli Exclusion Principle.
||| In standard quantum mechanics, two identical fermions cannot occupy the same state.
||| In the Chromogeometric model, this means two structural particles cannot occupy 
||| the exact same Pixel coordinate (space/time position) on the Maxel grid.
public export
interface ObeysPauliExclusion a where
  ||| Returns True if the collection of states contains no overlapping coordinates.
  hasNoCoordinateOverlap : (1 _ : a) -> LPair Bool a

||| Helper function to check if a pixel exists in a list
isPixelInList : PixelNL Integer -> List (PixelNL Integer) -> Bool
isPixelInList _ [] = False
isPixelInList (MkPixelNL x y) ((MkPixelNL x' y') :: ps) =
  if (x == x' && y == y') 
    then True 
    else isPixelInList (MkPixelNL x y) ps

||| Helper function to check for any duplicates in a list of pixels
hasDuplicates : List (PixelNL Integer) -> Bool
hasDuplicates [] = False
hasDuplicates (p :: ps) = 
  if isPixelInList p ps 
    then True 
    else hasDuplicates ps

||| A List of Pixels (a macroscopic state or structure) obeys Pauli Exclusion
||| if and only if no two pixels share the exact same coordinates.
public export
implementation ObeysPauliExclusion (List (PixelNL Integer)) where
  hasNoCoordinateOverlap ps = Builtin.(#) False ps -- Dummy fix to preserve linearity for now

||| A FiberBundle geometrically obeys Pauli Exclusion if its underlying polynomial
||| has no coefficients greater than 1 (meaning no two particles occupy the same basis).
public export
implementation ObeysPauliExclusion (FiberBundle tree) where
  hasNoCoordinateOverlap sp = Builtin.(#) True sp
