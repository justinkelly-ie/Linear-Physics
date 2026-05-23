import Math.Polynumber
import Math.Topology.Poset
import Math.Topology.Sheaf

extractGeometrySize : Geometry -> Nat
extractGeometrySize (MkGeometry 3 Rigid) = 27
extractGeometrySize (MkGeometry _ (Foldable dof)) = dof
extractGeometrySize _ = 1

partitionSize : {geom : Geometry} -> Sheaf (Root name geom) Polynumber -> Nat
partitionSize {geom} _ = extractGeometrySize geom
