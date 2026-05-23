module Math.FractionalEvaluator

import Math.Fraction
import Math.IntPolynumber

%default total

||| Evaluates an IntPolynumber (a DenseAMSet of (alpha, beta)) given a fractional `s` for alpha.
||| We assume beta is always 0 (as is standard for SpreadPolynomials).
public export
evaluateIntPoly : IntPolynumber -> Spread -> Spread
evaluateIntPoly (MkDense terms) spread =
  let (posSum, negSum) = foldl accumulate (MkFraction 0 1, MkFraction 0 1) terms
  in subFraction posSum negSum
  where
    accumulate : (Fraction, Fraction) -> ((Nat, Nat), Integer) -> (Fraction, Fraction)
    accumulate (posAcc, negAcc) ((alphaPower, _), coeff) =
      let powered = powerFraction spread alphaPower
          mag = cast {to=Nat} (abs coeff)
          scaled = scaleFraction mag powered
      in if coeff >= 0 
           then (addFraction posAcc scaled, negAcc)
           else (posAcc, addFraction negAcc scaled)

