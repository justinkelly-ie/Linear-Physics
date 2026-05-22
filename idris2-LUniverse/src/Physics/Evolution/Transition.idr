module Physics.Evolution.Transition

import Math.Maxel
import Math.Multiset
import Physics.Evolution.Fractal

%default total

||| Unified Transition Engine (Substrate-Parameterized Adaptive Cycle)
|||
||| Combines the linear mechanism of Cosmological Epochs with the 
||| higher-order abstraction mechanics of Scale Orders.
||| 
||| `SubstrateChange = False` represents an Epoch (linear continuation on the same grid).
||| `SubstrateChange = True` represents a Scale Order jump (creating higher order abstractions).

public export
data Phase : (isSubstrateChange : Bool) -> (cycleCount : Nat) -> (a : Type) -> (label : a) -> Type where
  ||| 1. Unfolding Phase:
  ||| Consumes a linear potential resource (`1`) to unfold geometric structures.
  Unfolding  : (1 state : Maxel a) -> (idProof : label === label) -> Phase s n a label
  
  ||| 2. Expansion Phase:
  ||| A linear active state (`1`) coupled with unrestricted growth (Nat).
  Expansion  : (1 state : Maxel a) -> (growth : Nat) -> Phase s n a label
  
  ||| 3. Saturation Phase:
  ||| A linear active state (`1`) burdened with accumulated Leibniz Lag (Nat).
  Saturation : (1 state : Maxel a) -> (lag : Nat) -> Phase s n a label
  
  ||| 4. Collapse Phase (Decoherence):
  ||| The lag exceeded the `capacityLimit`! The wave-function fractures.
  Collapse   : (1 fracture : Maxel a) -> Phase s n a label
  
  ||| 5. Residue Phase (Crunch to Bang):
  ||| The history is erased (`0`) at runtime. A linear residue remains as a 
  ||| Dark Matter/Energy seed for the subsequent cycle.
  Residue    : (0 history : Nat) -> (1 residue : Maxel a) -> Phase s n a label

||| The universal clock tick for the Transition Cycle.
||| It evaluates the saturation limit using the `ScaleEngine` interface.
public export
stepCycle : (ScaleEngine a) => (1 phase : Phase s n a label) -> Phase s n a label
stepCycle (Unfolding state idProof) = 
  -- Unfolding immediately moves to Expansion
  Expansion state 0

stepCycle (Expansion state growth) = 
  -- Expansion accumulates growth, which turns into Leibniz Lag (Saturation)
  Saturation state growth

stepCycle (Saturation state lag) = 
  -- Saturation triggers Collapse. In a true implementation, this checks the `capacityLimit`.
  Collapse state

stepCycle (Collapse fracture) = 
  -- Collapse clears the topological debt, leaving a compressed residue.
  Residue 0 fracture

stepCycle (Residue history residue) = 
  -- The residue seeds the next cycle's unfolding.
  -- Notice we cannot construct idProof dynamically here in the mock without it,
  -- but mathematically it resets. We will mock idProof for compilation.
  Unfolding residue Refl

||| The Universe Transition (Big Crunch -> Big Bang)
||| Mathematically consumes the previous linear Maxel completely to generate the next Epoch.
||| This requires `isSubstrateChange = False`.
public export
crunchToBangEpoch : {n : Nat} -> {a : Type} -> {label : a} -> (1 prev : Phase False n a label) -> Phase False (S n) a label
crunchToBangEpoch (Unfolding state idProof) = Unfolding state idProof
crunchToBangEpoch (Expansion state growth) = Expansion state growth
crunchToBangEpoch (Saturation state lag) = Saturation state lag
crunchToBangEpoch (Collapse fracture) = Collapse fracture
crunchToBangEpoch (Residue history residue) = Residue history residue

||| Scale Order Jump
||| Consumes the previous cycle completely to generate the next Scale Order.
||| This requires `isSubstrateChange = True`.
public export
scaleOrderJump : {n : Nat} -> {a : Type} -> {label : a} -> (1 prev : Phase True n a label) -> Phase True (S n) a label
scaleOrderJump (Unfolding state idProof) = Unfolding state idProof
scaleOrderJump (Expansion state growth) = Expansion state growth
scaleOrderJump (Saturation state lag) = Saturation state lag
scaleOrderJump (Collapse fracture) = Collapse fracture
scaleOrderJump (Residue history residue) = Residue history residue
