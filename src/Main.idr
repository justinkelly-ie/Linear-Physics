module Main

import Control.App
import Control.App.Console



||| The global universe simulation environment.
||| We will scaffold AbsoluteVacuum as a linear state resource here next.
universeApp : Has [Console] e => App e ()
universeApp = do
  putStrLn "Initializing LUniverse Simulation..."
  putStrLn "Booting AbsoluteVacuum..."

main : IO ()
main = run universeApp
