#:________________________________________________________________
#  nassimp  |  Copyright (C) Ivan Mar (sOkam!)  |  BSD-3-Clause  |
#:________________________________________________________________
# std dependencies
import std/os
import std/strformat
import std/strutils


#_________________________________________________
# Helpers
#_____________________________
# TODO: Switch to execShellCmd when 2.0 devel becomes stable
proc sh (cmd :string; dir :string= ""; verb = false) :void=
  ## Executes the given shell command and writes the output to console.
  ## Same as the nimscript version, but usable at compile time in static blocks.
  ## Runs the command from `dir` when specified.
  when defined(windows): {.warning: "running `sh -c` commands on Windows has not been tested".}
  var command :string
  if dir != "":  command = &"cd {dir}; " & cmd
  else:          command = cmd
  if verb: echo command
  echo gorge(&"sh -c \"{$command}\"")
  # discard command.execShellCmd
#_____________________________
const thisDir   = currentSourcePath().parentDir()
const Cdir      = thisDir/"C"
const assimpDir = Cdir/"lib"
const inclDir   = Cdir/"include"/"assimp"


#_________________________________________________
# Build Assimp
#_____________________________
# Note: Cannot be a nimble task
#   assimp should be built with either debug or release, just like Nim code.
#   Nimble doesn't understand auto-defines, which makes it impossible to designate a nimble task for it.
#   Usually you would compile C code with {.compile.} pragmas and nim
#   But this system calls for the default CMake Assimp buildsystem instead.
#_____________________________
# https://github.com/assimp/assimp/blob/master/Build.md
# BUILD_SHARED_LIBS (default ON): Generation of shared libs (dll for windows, so for Linux). Set this to OFF to get a static lib.
static:
  when defined(debug):
    let mode = "Debug"
  else:
    let mode = "Release"
  let cores = 8
  let opts = [
    "CMakeLists.txt",
    &"-DCMAKE_BUILD_TYPE={mode}",
    "-DASSIMP_BUILD_ZLIB=ON",
    "-DASSIMP_BUILD_MINIZIP=ON",
    "-DUSE_STATIC_CRT=ON",
    "-DASSIMP_BUILD_ASSIMP_TOOLS=OFF",
    "-DBUILD_SHARED_LIBS=OFF",
    "-DASSIMP_INSTALL=OFF",
    "-DASSIMP_BUILD_TESTS=OFF",
    "-DASSIMP_WARNINGS_AS_ERRORS=OFF",
    ] # << CMake options
  echo &": Compiling Assimp in {mode} mode..."
  sh &"cmake {opts.join(\" \")}; cmake --build . -j{cores}", CDir, verb=true

#_________________________________________________
# Static link to the Assimp.CMake resulting file
#_____________________________
{.passL: "-lstdc++ -lz -lminizip".}
{.passC: &"-I{inclDir}".}
{.passL: &"-L{assimpDir}"}
when defined(windows) and defined(debug):
  {.passL: "-l:libassimpd.lib".}
elif defined(windows):
  {.passL: "-l:libassimp.lib".}
elif defined(unix) and defined(debug):
  {.passL: "-l:libassimpd.a".}
elif defined(unix):
  {.passL: "-l:libassimp.a".}
else: {.error: &"System {hostOS} not recognized".}

