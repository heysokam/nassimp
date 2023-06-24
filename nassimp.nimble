#:________________________________________________________________
#  nassimp  |  Copyright (C) Ivan Mar (sOkam!)  |  BSD-3-Clause  |
#:________________________________________________________________
import std/os
import std/strformat


#_____________________________
# Package
packageName   = "nassimp"
version       = "0.0.0"
author        = "sOkam"
description   = "Static Assimp Wrapper for Nim"
license       = "BSD-3-Clause"


#_____________________________
# Build Requirements
requires "nim >= 1.6.12"
requires "https://github.com/heysokam/nmath"
requires "chroma"


#_____________________________
# Folders
srcDir        = "src"
binDir        = "bin"
let Cdir      = srcDir/packageName/"C"

