module Tests.Common

import Math.FiberBundle

%default total

||| Allows the QuickCheck framework to formally print out the physical topology
||| of any SpacetimeManifold if a universe fails a test!
public export
Show SpacetimeManifold where
  show (Root label _) = "[Root: " ++ label ++ "]"
  show (Node label parent _ _) = show parent ++ " -> " ++ "[Node: " ++ label ++ "]"
