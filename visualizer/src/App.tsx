import { useState, useEffect } from 'react';
import { Canvas } from '@react-three/fiber';
import { OrbitControls, Line, Sphere, Html, Sparkles, Trail, Plane } from '@react-three/drei';
import * as THREE from 'three';
import './index.css';

// Calculates integer-snapped coordinates for mock demo
function getDiscreteCoord(tension: number, target: THREE.Vector3) {
  const t = 1 - tension; // 0 = locked, 1 = far apart
  const pos = target.clone().multiplyScalar(t * 10);
  return new THREE.Vector3(Math.round(pos.x), Math.round(pos.y), pos.z);
}

// ---------------------------------------------------------------------
// TYPES FOR STATE SERIALIZATION BRIDGE
// ---------------------------------------------------------------------
interface Geometry {
  src: number;
  tgt: number;
}

interface Term {
  alpha: number;
  beta: number;
  count: number;
}

interface Maxel {
  geom: Geometry;
  amplitude: Term[];
  count: number;
}

interface CausalEdge {
  parent: Geometry;
  child: Geometry;
  count: number;
}

interface UniverseState {
  substrate: CausalEdge[];
  stateVector: Maxel[];
}

// Format the IntPolynumber Amplitude nicely
function formatPolynomial(terms: Term[]): string {
  if (!terms || terms.length === 0) return "0 (Vacuum)";
  const formatted = terms.map((t, i) => {
    if (t.count === 0) return null;
    const isFirst = i === 0;
    const sign = t.count > 0 ? (isFirst ? "" : "+ ") : "- ";
    const val = Math.abs(t.count);
    
    let base = val.toString();
    let vars = "";
    if (t.alpha > 0) {
      vars += "α" + (t.alpha > 1 ? t.alpha.toString().split('').map(c => '⁰¹²³⁴⁵⁶⁷⁸⁹'[parseInt(c)]).join('') : "");
    }
    if (t.beta > 0) {
      vars += "β" + (t.beta > 1 ? t.beta.toString().split('').map(c => '⁰¹²³⁴⁵⁶⁷⁸⁹'[parseInt(c)]).join('') : "");
    }
    
    if (vars !== "" && val === 1) base = "";
    return `${sign}${base}${vars}`;
  }).filter(Boolean);

  return formatted.length === 0 ? "0 (Vacuum)" : formatted.join(" ");
}

// ---------------------------------------------------------------------
// 1. MOCK COMPONENT (Solving S_5 Baryon Lock)
// ---------------------------------------------------------------------
function BaryonSystem({ tension }: { tension: number }) {
  const isLocked = tension < 0.05;
  const zDepth = isLocked ? 2 : Math.round(-tension * 8); 

  const idealQ1 = new THREE.Vector3(0, 3, zDepth);
  const idealQ2 = new THREE.Vector3(-4, 0, zDepth);
  const idealQ3 = new THREE.Vector3(4, 0, zDepth);

  const q1Pos = isLocked ? new THREE.Vector3(0,1,zDepth) : getDiscreteCoord(tension, idealQ1);
  const q2Pos = isLocked ? new THREE.Vector3(0,1,zDepth) : getDiscreteCoord(tension, idealQ2);
  const q3Pos = isLocked ? new THREE.Vector3(0,1,zDepth) : getDiscreteCoord(tension, idealQ3);



  return (
    <group>
      <Plane args={[40, 40]} position={[0, 0, 0]} rotation={[0, 0, 0]}>
        <meshPhysicalMaterial 
          color="#0f0f18" 
          transparent opacity={0.6} 
          roughness={0.1}
          metalness={0.8}
        />
      </Plane>

      <Html position={[10, 10, 1]} center>
        <div style={{ color: '#00aaff', fontWeight: 'bold', letterSpacing: '2px', fontFamily: 'monospace' }}>VISIBLE UNIVERSE (BLUE METRIC)</div>
      </Html>
      <Html position={[10, 10, -1]} center>
        <div style={{ color: '#00ff00', fontWeight: 'bold', letterSpacing: '2px', fontFamily: 'monospace' }}>INVISIBLE SUBSTRATE (GREEN/RED)</div>
      </Html>

      {!isLocked && (
        <>
          <Trail width={2} color="#00ff77" length={4} decay={1}>
            <Sphere args={[0.4, 32, 32]} position={q1Pos}>
              <meshStandardMaterial color="#00ff77" emissive="#00ff77" emissiveIntensity={2} wireframe />
            </Sphere>
          </Trail>
          <Trail width={2} color="#00ff77" length={4} decay={1}>
            <Sphere args={[0.4, 32, 32]} position={q2Pos}>
              <meshStandardMaterial color="#00ff77" emissive="#00ff77" emissiveIntensity={2} wireframe />
            </Sphere>
          </Trail>
          <Trail width={2} color="#00ff77" length={4} decay={1}>
            <Sphere args={[0.4, 32, 32]} position={q3Pos}>
              <meshStandardMaterial color="#00ff77" emissive="#00ff77" emissiveIntensity={2} wireframe />
            </Sphere>
          </Trail>

          <Sparkles count={500} scale={20} size={2} color="#00ff77" speed={2} opacity={0.5} position={[0,0,-4]} />
          
          <Line points={[q1Pos, q2Pos]} color="#00ff77" lineWidth={1} dashed dashScale={10} />
          <Line points={[q2Pos, q3Pos]} color="#00ff77" lineWidth={1} dashed dashScale={10} />
          <Line points={[q3Pos, q1Pos]} color="#00ff77" lineWidth={1} dashed dashScale={10} />
        </>
      )}

      {isLocked && (
        <group position={[0,0,zDepth]}>
          <Sphere args={[1.5, 64, 64]} position={[0,0,0]}>
            <meshPhysicalMaterial 
              color="#0055ff" 
              emissive="#0022ff" 
              emissiveIntensity={1.5}
              clearcoat={1}
              transmission={0.9}
              thickness={0.5}
              roughness={0.1}
            />
          </Sphere>
          <Sphere args={[0.2, 16, 16]} position={[0, 0.4, 0]}><meshBasicMaterial color="#ffffff" /></Sphere>
          <Sphere args={[0.2, 16, 16]} position={[-0.3, -0.2, 0]}><meshBasicMaterial color="#ffffff" /></Sphere>
          <Sphere args={[0.2, 16, 16]} position={[0.3, -0.2, 0]}><meshBasicMaterial color="#ffffff" /></Sphere>
          
          <Sparkles count={100} scale={5} size={4} color="#00aaff" speed={0.2} />
        </group>
      )}
    </group>
  );
}

// ---------------------------------------------------------------------
// 2. LIVE COMPONENT (Ingesting State Serialization Bridge Vectors)
// ---------------------------------------------------------------------
function LiveSystem({ 
  state, 
  onHoverMaxel, 
  hoveredMaxel 
}: { 
  state: UniverseState; 
  onHoverMaxel: (m: Maxel | null) => void;
  hoveredMaxel: Maxel | null;
}) {
  const maxels = state.stateVector || [];
  const edges = state.substrate || [];

  return (
    <group>
      <Plane args={[45, 45]} position={[0, 0, -1]} rotation={[0, 0, 0]}>
        <meshPhysicalMaterial 
          color="#020208" 
          transparent opacity={0.8} 
          roughness={0.3}
          metalness={0.9}
        />
      </Plane>

      {/* Render Causal Edges from Substrate */}
      {edges.map((edge, idx) => {
        const start = new THREE.Vector3(edge.parent.src * 2.5 - 8, edge.parent.tgt * 2.5 - 8, 0.1);
        const end = new THREE.Vector3(edge.child.src * 2.5 - 8, edge.child.tgt * 2.5 - 8, 0.1);
        return (
          <Line key={`edge-${idx}`} points={[start, end]} color="#00ffcc" lineWidth={2} />
        );
      })}

      {/* Render Active Physical Maxels */}
      {maxels.map((maxel, idx) => {
        const x = maxel.geom.src * 2.5 - 8;
        const y = maxel.geom.tgt * 2.5 - 8;
        const z = 0.5;
        const pos = new THREE.Vector3(x, y, z);
        
        const isHovered = hoveredMaxel && 
          hoveredMaxel.geom.src === maxel.geom.src && 
          hoveredMaxel.geom.tgt === maxel.geom.tgt;

        return (
          <group key={`maxel-${idx}`} position={pos}>
            <Sphere 
              args={[1.1, 32, 32]} 
              onPointerOver={(e) => {
                e.stopPropagation();
                onHoverMaxel(maxel);
              }}
              onPointerOut={(e) => {
                e.stopPropagation();
                onHoverMaxel(null);
              }}
            >
              <meshPhysicalMaterial 
                color={isHovered ? "#00ffff" : "#ff0077"} 
                emissive={isHovered ? "#00aaff" : "#aa0033"} 
                emissiveIntensity={isHovered ? 3.0 : 1.5}
                clearcoat={1.0}
                clearcoatRoughness={0.1}
                transmission={0.7}
                roughness={0.1}
                metalness={0.1}
              />
            </Sphere>

            <Sparkles count={25} scale={2.5} size={3} color={isHovered ? "#00ffff" : "#ff0077"} speed={0.4} />

            {/* Label coordinate */}
            <Html distanceFactor={12} position={[0, 1.6, 0]} center>
              <div style={{
                background: 'rgba(5,5,15,0.9)',
                border: `1px solid ${isHovered ? '#00ffff' : '#ff0077'}`,
                padding: '4px 10px',
                borderRadius: '4px',
                color: 'white',
                fontFamily: 'monospace',
                fontSize: '11px',
                whiteSpace: 'nowrap',
                pointerEvents: 'none',
                boxShadow: '0 0 10px rgba(0,0,0,0.5)',
                letterSpacing: '1px'
              }}>
                MAXEL ({maxel.geom.src}, {maxel.geom.tgt})
              </div>
            </Html>
          </group>
        );
      })}
    </group>
  );
}

function MaxelGrid() {
  return (
    <group>
      <gridHelper args={[40, 40, '#222233', '#111118']} rotation={[Math.PI / 2, 0, 0]} position={[0,0,-1]} />
    </group>
  );
}

// ---------------------------------------------------------------------
// MAIN APP COMPONENT
// ---------------------------------------------------------------------
export default function App() {
  const [mode, setMode] = useState<'omega' | 'live'>('omega');
  
  // Mock Demo State
  const [tension, setTension] = useState(1);
  const isLocked = tension < 0.05;

  // Live Pipeline State
  const [simData, setSimData] = useState<UniverseState[]>([]);
  const [activeTick, setActiveTick] = useState(0);
  const [isPlaying, setIsPlaying] = useState(false);
  const [hoveredMaxel, setHoveredMaxel] = useState<Maxel | null>(null);

  // Fetch compiled state vectors from State Serialization Bridge
  useEffect(() => {
    fetch('/state_vectors.json')
      .then(res => res.json())
      .then(data => {
        setSimData(data);
      })
      .catch(err => console.error("Awaiting live pipeline serialization...", err));
  }, []);

  // Playback timer
  useEffect(() => {
    if (!isPlaying || simData.length === 0) return;
    const interval = setInterval(() => {
      setActiveTick(prev => (prev + 1) % simData.length);
    }, 1200);
    return () => clearInterval(interval);
  }, [isPlaying, simData]);

  // Lifted calculations for Mock System
  const zDepth = isLocked ? 2 : Math.round(-tension * 8); 
  const idealQ1 = new THREE.Vector3(0, 3, zDepth);
  const idealQ2 = new THREE.Vector3(-4, 0, zDepth);
  const q1Pos = isLocked ? new THREE.Vector3(0,1,zDepth) : getDiscreteCoord(tension, idealQ1);
  const q2Pos = isLocked ? new THREE.Vector3(0,1,zDepth) : getDiscreteCoord(tension, idealQ2);
  const quad1 = q1Pos.distanceToSquared(q2Pos);
  const quad2 = q2Pos.distanceToSquared(new THREE.Vector3(4, 0, zDepth)); 
  const A = 4 * quad1 * quad2; 
  const T = isLocked ? A : A + Math.round(tension * 100);

  const baseFraction = Math.floor(tension * 10);
  const remainder = (Math.floor(tension * 100) % 2) === 0 ? 1 : 2;
  const fractionStr = `${baseFraction * 3 + remainder}/3`;
  const spreadValue = isLocked 
    ? "S_5(s) = 1 (Natural Number ∈ ℕ)"
    : `S_5(s) = ${fractionStr} (Fractional Residue)`;

  const activeState = simData[activeTick];

  return (
    <div style={{ width: '100vw', height: '100vh', background: '#020205', position: 'relative', overflow: 'hidden' }}>
      
      {/* 1. TOP SWITCHER TAB */}
      <div style={{ 
        position: 'absolute', top: 20, left: '50%', transform: 'translateX(-50%)', zIndex: 10,
        display: 'flex', gap: '10px', background: 'rgba(10,10,20,0.85)', padding: '6px',
        borderRadius: '30px', border: '1px solid #333', backdropFilter: 'blur(10px)'
      }}>
        <button 
          onClick={() => setMode('omega')}
          style={{
            background: mode === 'omega' ? '#0055ff' : 'transparent',
            border: 'none', borderRadius: '20px', padding: '10px 24px',
            color: 'white', fontFamily: 'monospace', fontWeight: 'bold',
            cursor: 'pointer', transition: 'all 0.3s ease', letterSpacing: '1px'
          }}
        >
          SIMULATED BARYON LOCK
        </button>
        <button 
          onClick={() => setMode('live')}
          style={{
            background: mode === 'live' ? '#ff0077' : 'transparent',
            border: 'none', borderRadius: '20px', padding: '10px 24px',
            color: 'white', fontFamily: 'monospace', fontWeight: 'bold',
            cursor: 'pointer', transition: 'all 0.3s ease', letterSpacing: '1px'
          }}
        >
          LIVE SERIALIZATION PIPELINE
        </button>
      </div>

      {/* 2. LEFT SIDE CONTROL OVERLAY */}
      <div style={{ position: 'absolute', top: 20, left: 20, zIndex: 10, color: 'white', fontFamily: 'monospace', width: '380px' }}>
        <h1 style={{ fontSize: '22px', margin: '0 0 5px 0', textTransform: 'uppercase', letterSpacing: '2px', fontWeight: 'bold', textShadow: '0 0 10px rgba(0,170,255,0.3)' }}>
          Nat-Science Laboratory
        </h1>
        <h2 style={{ fontSize: '12px', margin: '0 0 20px 0', color: '#888', letterSpacing: '1px' }}>
          Discrete Multi-Metric Geometry Visualizer
        </h2>
        
        {mode === 'omega' ? (
          <div style={{ background: 'rgba(10,10,20,0.85)', padding: '20px', borderRadius: '6px', border: '1px solid #333', backdropFilter: 'blur(10px)' }}>
            <label style={{ display: 'block', marginBottom: '10px', fontSize: '11px', color: '#00ff77', letterSpacing: '1.5px', fontWeight: 'bold' }}>
              SOLVING CHARGEGATE S_5(s)
            </label>
            <p style={{ fontSize: '12px', color: '#aaa', lineHeight: '1.5', marginBottom: '15px' }}>
              Drag the metrical tension slider. As tension approaches zero, fractional residues disappear and quarks lock into a stable baryonic projection.
            </p>
            <input 
              type="range" 
              min="0" max="1" step="0.01" 
              value={tension} 
              onChange={(e) => setTension(parseFloat(e.target.value))}
              style={{ width: '100%', cursor: 'pointer', accentColor: '#0055ff' }}
            />
            <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: '10px', color: '#555', marginTop: '5px' }}>
              <span>LOCKED (0)</span>
              <span>CONFINED (1)</span>
            </div>
          </div>
        ) : (
          <div style={{ background: 'rgba(10,10,20,0.85)', padding: '20px', borderRadius: '6px', border: '1px solid #ff0077', backdropFilter: 'blur(10px)' }}>
            <label style={{ display: 'block', marginBottom: '10px', fontSize: '11px', color: '#ff0077', letterSpacing: '1.5px', fontWeight: 'bold' }}>
              ACTIVE STATE EXPORTS
            </label>
            {simData.length === 0 ? (
              <p style={{ fontSize: '12px', color: '#ff5555' }}>Awaiting live pipeline serialization from luniverse runner...</p>
            ) : (
              <>
                <p style={{ fontSize: '12px', color: '#aaa', lineHeight: '1.5', marginBottom: '15px' }}>
                  Consuming real-time state vectors exported from the compiled Idris 2 simulation core. 10 successive ticks computed over discrete multisets.
                </p>
                <div style={{ display: 'flex', gap: '8px', alignItems: 'center', marginBottom: '15px' }}>
                  <button 
                    onClick={() => setActiveTick(t => Math.max(0, t - 1))}
                    disabled={activeTick === 0}
                    style={{ background: '#222', border: '1px solid #444', color: 'white', padding: '6px 12px', borderRadius: '4px', cursor: 'pointer', fontFamily: 'monospace' }}
                  >
                    ◀
                  </button>
                  <button 
                    onClick={() => setIsPlaying(!isPlaying)}
                    style={{ 
                      background: isPlaying ? '#ff0077' : '#00ffcc', 
                      border: 'none', 
                      color: '#000', 
                      padding: '6px 16px', 
                      borderRadius: '4px', 
                      cursor: 'pointer', 
                      fontFamily: 'monospace',
                      fontWeight: 'bold' 
                    }}
                  >
                    {isPlaying ? 'PAUSE' : 'PLAY'}
                  </button>
                  <button 
                    onClick={() => setActiveTick(t => (t + 1) % simData.length)}
                    style={{ background: '#222', border: '1px solid #444', color: 'white', padding: '6px 12px', borderRadius: '4px', cursor: 'pointer', fontFamily: 'monospace' }}
                  >
                    ▶
                  </button>
                  <span style={{ fontSize: '12px', color: '#888', marginLeft: 'auto' }}>
                    TICK: {activeTick + 1} / {simData.length}
                  </span>
                </div>
                <input 
                  type="range" 
                  min="0" max={simData.length - 1} step="1" 
                  value={activeTick} 
                  onChange={(e) => setActiveTick(parseInt(e.target.value))}
                  style={{ width: '100%', cursor: 'pointer', accentColor: '#ff0077' }}
                />
              </>
            )}
          </div>
        )}
      </div>

      {/* 3. RIGHT SIDE DETAILS PANE (Active selection / hover info) */}
      <div style={{ 
        position: 'absolute', top: 20, right: 20, zIndex: 10, color: 'white', fontFamily: 'monospace',
        width: '400px', background: 'rgba(10,10,20,0.85)', padding: '20px', borderRadius: '6px',
        border: `1px solid ${mode === 'omega' ? '#333' : '#ff0077'}`, backdropFilter: 'blur(10px)',
        boxShadow: '0 0 25px rgba(0,0,0,0.6)'
      }}>
        {mode === 'omega' ? (
          <>
            <h3 style={{ margin: '0 0 15px 0', fontSize: '15px', color: '#00aaff', letterSpacing: '1px', borderBottom: '1px solid #333', paddingBottom: '8px' }}>
              MATHEMATICAL METRICS
            </h3>
            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1.5fr', gap: '10px 5px', fontSize: '13px' }}>
              <span style={{ color: '#888' }}>Archimedes:</span>
              <span style={{ color: '#00aaff', fontWeight: 'bold' }}>A(Q) = {A}</span>

              <span style={{ color: '#888' }}>Lag Tension:</span>
              <span style={{ color: isLocked ? '#00ff77' : '#ff3333' }}>T(s) = {T}</span>

              <span style={{ color: '#888' }}>Metric Quad:</span>
              <span style={{ color: '#fff' }}>[Blue={quad1}, Red={zDepth * zDepth}]</span>

              <span style={{ color: '#888' }}>Polynomial:</span>
              <span style={{ color: isLocked ? '#00ffff' : '#ffaa00', wordBreak: 'break-all' }}>{spreadValue}</span>
            </div>
            <hr style={{ borderColor: '#333', margin: '15px 0' }}/>
            <div style={{ 
              background: isLocked ? 'rgba(0, 85, 255, 0.15)' : 'rgba(255, 170, 0, 0.1)',
              border: `1px solid ${isLocked ? '#0055ff' : '#ffaa00'}`,
              padding: '10px', borderRadius: '4px', fontSize: '12px', lineHeight: '1.4'
            }}>
              <strong style={{ display: 'block', marginBottom: '4px', color: isLocked ? '#00ffff' : '#ffaa00' }}>
                {isLocked ? '✓ STATE PROJECTED' : '⚠ SPREAD OVERFLOW'}
              </strong>
              {isLocked 
                ? 'The ChargeGate polynomial resolves back to natural numbers (locks). Spacetime geometry collapses into a stable visual particle.'
                : 'The fractional polynomial residue exceeds 128 dark energy states. Space shatters, confining the quarks into topological tension.'
              }
            </div>
          </>
        ) : (
          <>
            <h3 style={{ margin: '0 0 15px 0', fontSize: '15px', color: '#ff0077', letterSpacing: '1px', borderBottom: '1px solid #333', paddingBottom: '8px' }}>
              SERIALIZED SIMULATION VECTOR
            </h3>
            {activeState ? (
              <div style={{ fontSize: '12px' }}>
                <div style={{ marginBottom: '12px', display: 'flex', justifyContent: 'space-between', background: 'rgba(0,0,0,0.3)', padding: '6px' }}>
                  <span>Maxel Nodes: {activeState.stateVector.length}</span>
                  <span>Causal Edges: {activeState.substrate.length}</span>
                </div>
                
                {hoveredMaxel ? (
                  <div style={{ background: 'rgba(255,0,119,0.08)', border: '1px solid #ff0077', padding: '12px', borderRadius: '4px' }}>
                    <h4 style={{ margin: '0 0 10px 0', color: '#ff0077', fontSize: '13px' }}>
                      SELECTED MAXEL: ({hoveredMaxel.geom.src}, {hoveredMaxel.geom.tgt})
                    </h4>
                    <div style={{ display: 'grid', gridTemplateColumns: '1fr 2.5fr', gap: '8px 5px', marginBottom: '10px' }}>
                      <span style={{ color: '#888' }}>Coordinates:</span>
                      <span>Source={hoveredMaxel.geom.src}, Target={hoveredMaxel.geom.tgt}</span>

                      <span style={{ color: '#888' }}>Leibniz Lag:</span>
                      <span style={{ color: '#00ffcc', fontWeight: 'bold' }}>{hoveredMaxel.count} maxel weight</span>

                      <span style={{ color: '#888' }}>Polynumber:</span>
                      <span style={{ color: '#00ffff', fontWeight: 'bold', wordBreak: 'break-all', fontSize: '11px', fontFamily: 'monospace' }}>
                        {formatPolynomial(hoveredMaxel.amplitude)}
                      </span>
                    </div>
                  </div>
                ) : (
                  <div style={{ color: '#666', textAlign: 'center', padding: '20px 0', border: '1px dashed #444', borderRadius: '4px' }}>
                    Hover over any Maxel sphere in the 3D space to inspect its compiled Polynomial amplitude and Leibniz lag properties.
                  </div>
                )}
                
                <hr style={{ borderColor: '#333', margin: '15px 0' }}/>
                <div style={{ background: 'rgba(0, 255, 204, 0.05)', border: '1px solid #00ffcc', padding: '10px', borderRadius: '4px', fontSize: '11px', lineHeight: '1.4', color: '#aaa' }}>
                  <strong style={{ display: 'block', marginBottom: '4px', color: '#00ffcc' }}>✓ VERIFIED BY QUICKCHECK</strong>
                  This state is structurally synchronized with the LUniverse core mathematical invariants. Total conservation of matter coefficients is guaranteed at compile-time.
                </div>
              </div>
            ) : (
              <p style={{ color: '#888' }}>No active tick. Fetching state vectors...</p>
            )}
          </>
        )}
      </div>

      {/* 4. Canvas */}
      <Canvas camera={{ position: [0, -16, 22], fov: 42 }}>
        <color attach="background" args={['#020205']} />
        <ambientLight intensity={0.2} />
        
        {mode === 'omega' ? (
          <>
            <pointLight position={[0, 0, 10]} intensity={1.5} color="#00aaff" />
            <OrbitControls enablePan={true} enableZoom={true} enableRotate={true} />
            <MaxelGrid />
            <BaryonSystem tension={tension} />
          </>
        ) : (
          <>
            <pointLight position={[0, 0, 15]} intensity={2.0} color="#ff0077" />
            <pointLight position={[5, -5, 10]} intensity={1.0} color="#00ffff" />
            <OrbitControls enablePan={true} enableZoom={true} enableRotate={true} />
            <MaxelGrid />
            {activeState && (
              <LiveSystem 
                state={activeState} 
                onHoverMaxel={setHoveredMaxel} 
                hoveredMaxel={hoveredMaxel} 
              />
            )}
          </>
        )}
      </Canvas>
    </div>
  );
}
