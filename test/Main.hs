module Main where

import Test.Hspec.Runner
import Test.Hspec.Formatters
import System.Exit (ExitCode(ExitSuccess), exitFailure)
import Control.Monad (when)
import System.Process (createProcess, proc, waitForProcess)
import qualified Spec

envStart :: IO Bool
envStart = do
    (_, _, _, p) <- createProcess (proc "grakn-spec/env.sh" ["start"])
    code <- waitForProcess p
    return $ code == ExitSuccess

envStop :: IO ()
envStop = do
    (_, _, _, p) <- createProcess (proc "grakn-spec/env.sh" ["stop"])
    waitForProcess p
    return ()

main :: IO ()
main = do
    started <- envStart
    if started
    then do
        hspecWith defaultConfig Spec.spec
        envStop
    else exitFailure
