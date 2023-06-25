#:________________________________________________________________
#  nassimp  |  Copyright (C) Ivan Mar (sOkam!)  |  BSD-3-Clause  |
#:________________________________________________________________
import std/os
import std/strformat


#_____________________________
# Package
packageName   = "nassimp"
version       = "5.2.5.0"  # First three numbers in sync with assimp
author        = "sOkam"
description   = "Static Assimp Wrapper for Nim"
license       = "BSD-3-Clause"


#_____________________________
# Build Requirements
requires "nim >= 1.6.12"


#_____________________________
# Folders
srcDir        = "src"
binDir        = "bin"
let testsDir  = "tests"
let Cdir      = srcDir/packageName/"C"


#________________________________________
# Build tasks
#___________________
task git, " Internal:  Updates the assimp submodule.":
  ## Updates the submodule, and hard reset/clean everything in the folder
  exec &"git submodule update --recursive {Cdir}"
  withDir Cdir:
    exec "git pull"
    exec "git reset --hard HEAD"
    exec "git clean -fdx"
#___________________
task push, "Internal:  Pushes the git repository, and orders to create a new git tag for the package, using the latest version.":
  ## Does nothing when local and remote versions are the same.
  requires "https://github.com/beef331/graffiti.git"
  exec "git push"  # Requires local auth
  exec "graffiti ./confy.nimble"

