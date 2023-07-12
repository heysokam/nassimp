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
test &"importFile {bottleFile}":
  let scn = ai.importFile(bottleFile)
  # Contents
  check scn.getName() == "Scene"
  check scn.meshCount == 1
  check scn.hasMaterials()
  check not scn.hasAnimations()
  check not scn.hasTextures()
  check not scn.hasLights()
  check not scn.hasCameras()
  check not scn.hasSkeletons()
  # Flags
  check not scn.isIncomplete()
  check not scn.isValidated()
  check not scn.hasValidationWRN()
  check not scn.hasNonVerboseFmt()
  check not scn.isTerrain()
  check not scn.allowsSharedData()
  # Model contents
  let mdl = scn.getModelData( scn.getRoot() )
  check mdl[0].pos != newSeq[extras.Vector3]()
  # check mdl[0].pos != newSeq[Vec3]()
  # check mdl[0].pos[0] == vec3(-98.7689208984375, -253.5404205322266, 15.64341735839844)
  ai.release(scn)

#_______________________________________
const spheresFile = resDir/"mrSpheres/MetalRoughSpheres.gltf"
test &"importFile {spheresFile}":
  let scn = ai.importFile(spheresFile)
  # Contents
  check scn.getName() == ""
  check scn.meshCount == 5
  check scn.hasMaterials()
  check not scn.hasAnimations()
  check not scn.hasTextures()
  check not scn.hasLights()
  check not scn.hasCameras()
  check not scn.hasSkeletons()
  # Flags
  check not scn.isIncomplete()
  check not scn.isValidated()
  check not scn.hasValidationWRN()
  check not scn.hasNonVerboseFmt()
  check not scn.isTerrain()
  check not scn.allowsSharedData()
  ai.release(scn)

