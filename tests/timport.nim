#:____________________________________________________
#  nimp  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
# std dependencies
import std/unittest
import std/strformat
import std/os
# Library dependencies
import nassimp as ai

#_______________________________________
# Config
const resDir = currentSourcePath().parentDir()/"res"
#_____________________________


#_______________________________________
const bottleFile = resDir/"bottle/bottle.gltf"
test &"load {bottleFile}":
  let scn = ai.importFile(bottleFile)
  check scn.meshCount == 1
  check scn.getName() == "Scene"
  # check mdl[0].pos != newSeq[Vec3]()
  # check mdl[0].pos[0] == vec3(-98.7689208984375, -253.5404205322266, 15.64341735839844)

#_______________________________________
const spheresFile = resDir/"mrSpheres/MetalRoughSpheres.gltf"
test &"load {spheresFile}":
  let scn = ai.importFile(spheresFile)
  check scn.meshCount == 5

