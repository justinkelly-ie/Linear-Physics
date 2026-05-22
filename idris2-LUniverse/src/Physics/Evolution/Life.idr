module Physics.Evolution.Life

import Physics.Evolution.Transition
import Physics.Evolution.Observer
import Universe.DarkPlusMatter
import Math.Maxel
import Math.Multiset

%default total

||| Scale Order 4: The Biological Emergence (Life)
|||
||| In standard biology, life is viewed as an emergent property of complex chemistry
||| driven by thermodynamic chance. 
|||
||| In the LUniverse model, Life is a strict mathematical necessity! 
||| As the Molecular Scale Order (chemistry) composed higher and higher spread polynomials 
||| (generating complex macromolecules), it accumulated massive fractional Leibniz Lag. 
||| To avoid a catastrophic Grid Fracture (Decoherence/Death), the system had no choice 
||| but to jump to a higher-order abstraction.
|||
||| Life is defined mathematically as the instantiation of Autopoiesis (self-creation) 
||| on the Rational Grid. It is a closed geometric loop that uses the DNA substrate 
||| to endlessly execute the Adaptive Cycle (`Phase` transitions), constantly neutralizing 
||| its topological debt by transferring its QTT Linear Identity (`1`) to new 
||| structural offspring (never clones, as dictated by the No-Cloning Theorem) 
||| just before wave-function collapse. A single system can instantiate multiple 
||| offspring simultaneously by consuming multiple environmental substrates!

public export
data BiologicalSystem : (a : Type) -> Type where
  ||| A biological system is mathematically just a highly scaled geometric wrapper
  ||| around a linear Maxel state (which wraps the underlying Multiset).
  MkBiologicalSystem : (1 state : Maxel a) -> 
                       (cellularComplexity : Nat) -> 
                       (leibnizLag : Nat) -> 
                       BiologicalSystem a

||| A linear pair to return two BiologicalSystems without violating QTT.
public export
data BioPair : (a : Type) -> Type where
  MkBioPair : (1 b1 : BiologicalSystem a) -> (1 b2 : BiologicalSystem a) -> BioPair a

||| The formal definition of Biological Replication (Mitosis/Reproduction).
||| To preserve the strict QTT Linearity of the universe (the No-Cloning theorem),
||| a biological system does not "copy" itself in violation of physics. Instead,
||| it consumes environmental unallocated linear resources (a new Maxel) to construct 
||| a parallel identity, transferring the blueprint while zeroing out the Leibniz Lag 
||| for the offspring!
public export
replicateLife : {a : Type} -> 
                (1 parent : BiologicalSystem a) -> 
                (1 environment : Maxel a) -> 
                BioPair a
replicateLife (MkBiologicalSystem pState complexity lag) envState =
  -- The parent retains its core structural linear state but accumulates lag (aging).
  -- The offspring consumes the environmental Maxel state and starts with zero lag.
  let parentAged = MkBiologicalSystem pState complexity (lag + 1)
      offspring  = MkBiologicalSystem envState complexity 0
  in MkBioPair parentAged offspring

||| A linear triplet to return two parents and one offspring.
public export
data BioTriplet : (a : Type) -> Type where
  MkBioTriplet : (1 p1 : BiologicalSystem a) -> 
                 (1 p2 : BiologicalSystem a) -> 
                 (1 child : BiologicalSystem a) -> 
                 BioTriplet a

||| Sexual Reproduction (Meiosis / Genetic Recombination)
||| While basic autopoiesis (mitosis) requires only one parent, complex life evolved 
||| sexual reproduction as a higher-order topological error-correction mechanism.
||| Two parents linearly combine their geometric state with an environmental substrate
||| to produce an offspring that inherits resilience from both lineages.
public export
sexualReproduction : {a : Type} -> 
                     (1 parentA : BiologicalSystem a) -> 
                     (1 parentB : BiologicalSystem a) -> 
                     (1 environment : Maxel a) -> 
                     BioTriplet a
sexualReproduction (MkBiologicalSystem stateA compA lagA) (MkBiologicalSystem stateB compB lagB) envState =
  -- Both parents age (accumulate lag)
  let parentAgedA = MkBiologicalSystem stateA compA (lagA + 1)
      parentAgedB = MkBiologicalSystem stateB compB (lagB + 1)
      -- The offspring consumes the environmental Maxel state and inherits 
      -- the average structural complexity of its parents with zero lag.
      avgComp     = cast ((cast (compA + compB) {to=Integer}) `div` 2)
      offspring   = MkBiologicalSystem envState avgComp 0
  in MkBioTriplet parentAgedA parentAgedB offspring

||| Death is mathematically defined as Decoherence (Collapse).
||| When the Leibniz Lag exceeds the geometric capacity of the Biological Scale Order,
||| the structure loses its $A(Q) = T(s)$ lock and shatters back down to the 
||| Molecular Scale Order (decomposition).
public export
checkViability : {a : Type} -> BiologicalSystem a -> Bool
checkViability (MkBiologicalSystem _ complexity lag) =
  -- If topological debt exceeds the system's structural carrying capacity, it decoheres.
  lag < complexity
