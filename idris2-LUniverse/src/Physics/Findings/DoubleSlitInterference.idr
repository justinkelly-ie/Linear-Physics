module Physics.Findings.DoubleSlitInterference

import Math.FiberBundle
import Math.SpreadPolynomial
import Math.MaxelNL
import Math.Fraction
import Math.FractionalEvaluator
import Math.IntPolynumber
import Math.FractionalEvaluator

%default total

||| The Double Slit Interference Phenomenon (Without Waves)
||| 
||| In standard quantum mechanics, the double-slit experiment is often explained 
||| by invoking wave-particle duality, suggesting that a particle physically smears
||| into a probability wave to pass through both slits simultaneously.
||| 
||| In the deterministic Primorial architecture, we eliminate this continuity.
||| A particle does not become a wave; it remains a discrete point with a 
||| fractional input spread ($s$) moving across the Maxel grid.
||| 
||| The "interference pattern" observed on the detector screen is purely an
||| arithmetic projection of Spread Polynomials ($S_n(s)$).
||| 
||| 1. The Gateway ($S_n(s)$): As the fractional state passes through the experimental
||| apparatus, it is subjected to a Spread Polynomial Operator.
||| 
||| 2. Bright Fringes (Materialization): If the fractional input mathematically 
||| perfectly clears the polynomial's denominator, the output evaluates to a 
||| pure Integer. The particle instantly materializes on the Blue Metric grid, 
||| striking the screen. This creates a Bright Fringe.
||| 
||| 3. Dark Fringes (Invisible Fractions): If the polynomial evaluates to a 
||| rational fraction, the particle CANNOT map to the Blue Metric grid. It remains
||| an invisible Dark Energy state ($\mathbb{Q}$ space) and never registers on 
||| the screen. This creates the dark gaps between fringes.
||| 
||| The alternating bands of light and dark are literally just the geometric
||| distribution of integer solutions versus fractional remainders along the
||| polynomial's curve! No wave-function collapse is required.

public export
interface DoubleSlitProjector a where
  ||| Evaluates if a given fractional spread will clear its denominator 
  ||| and hit the detector (Bright Fringe) or remain hidden (Dark Fringe).
  ||| Returns True for Bright, False for Dark.
  projectsToBrightFringe : (input_spread : Spread) -> a -> Bool

||| A simplified mock structure for the Slit Geometry
public export
record SlitGeometry where
  constructor MkSlitGeometry
  gateDegree : Nat -- The tuning n value of the geometry


||| In this model, if the polynomial evaluation results in a mathematically 
||| whole number (no fractional remainder), the particle appears on the screen.
isDivisible : Nat -> Nat -> Bool
isDivisible Z _ = True
isDivisible _ Z = False
isDivisible n d = 
  case n `minus` d of
       Z => (n == d) -- If minus reached zero, it must be exact match
       diff => isDivisible (assert_smaller n diff) d

public export
implementation DoubleSlitProjector SlitGeometry where
  projectsToBrightFringe spread geom =
    let algebraicPoly = spreadPoly geom.gateDegree
        polyResult = evaluateIntPoly algebraicPoly spread
    in polyResult.denominator == 1 || isDivisible polyResult.numerator polyResult.denominator
