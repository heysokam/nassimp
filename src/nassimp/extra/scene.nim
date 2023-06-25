#:________________________________________________________________
#  nassimp  |  Copyright (C) Ivan Mar (sOkam!)  |  BSD-3-Clause  |
#:________________________________________________________________
# nassimp dependencies
import ../types
import ./convert

#_________________________________________________
# Fields access  : Ergonomics
#_____________________________
proc getRoot *(scn :ptr Scene) :ptr Node=  scn.rootNode
  ## Returns the root node of the given scene.
proc hasRoot *(scn :ptr Scene) :bool=  scn.getRoot != nil
  ## Returns true if the scene has a root node.
proc getName *(scn :ptr Scene) :string=  scn.name.toString
  ## Returns the name of the given scene.

#_________________________________________________
# Flags access  : Ergonomics
#_____________________________
func isIncomplete *(scn :ptr Scene) :bool=  SceneFlag.incomplete in scn.flags
  ## Returns true if the scene is marked as Incomplete by the importing process.
func isValidated *(scn :ptr Scene) :bool=  SceneFlag.validated in scn.flags
  ## Returns true if the scene validation process was successful.
func hasValidationWRN *(scn :ptr Scene) :bool=  SceneFlag.validationWRN in scn.flags
  ## Returns true if the validation process found issues.
  ## eg: a texture that does not exist is being referenced, etc
func hasNonVerboseFmt *(scn :ptr Scene) :bool=  SceneFlag.nonVerboseFmt in scn.flags
  ## Returns true if Process.joinIdenticalVerts set vertices to be nonVerbose.
  ## Verbose means all vertices are unique and not referenced by more than one face.
func isTerrain *(scn :ptr Scene) :bool=  SceneFlag.terrain in scn.flags
  ## Returns true if the scene is composed only of height-map terrain data.
func allowsSharedData *(scn :ptr Scene) :bool=  SceneFlag.allowShared in scn.flags
  ## Returns true if the scene data can be shared between structures.
  ## eg: one vertex in few faces

##[
type Scene *{.pure.}= object
  # flags          *:cint
  # rootNode       *:ptr Node
  meshCount      *:cint
  meshes         *:ptr UncheckedArray[ptr Mesh]
  materialCount  *:cint
  materials      *:ptr UncheckedArray[ptr Material]
  animationCount *:cint
  animations     *:ptr UncheckedArray[ptr Animation]
  textureCount   *:cint
  textures       *:ptr UncheckedArray[ptr Texture]
  lightCount     *:cint
  lights         *:ptr UncheckedArray[ptr Light]
  cameraCount    *:cint
  cameras        *:ptr UncheckedArray[ptr Camera]
  metaData       *:ptr Metadata
  # name           *:String
  numSkeletons   *:cuint
  skeletons      *:ptr ptr Skeleton
]##

#_________________________________________________
# Data iterators  : Ergonomics
#_____________________________
iterator imeshes *(scene :ptr Scene) :ptr Mesh=
  ## Yields all meshes of the given scene
  for x in 0..<scene.meshCount: yield scene.meshes[x]
#_____________________________
iterator imats *(scene :ptr Scene) :ptr Material=
  ## Yields all materials of the given scene
  for x in 0..<scene.materialCount: yield scene.materials[x]
#_____________________________
iterator ianims *(scene :ptr Scene) :ptr Animation=
  ## Yields all animations of the given scene
  for x in 0..<scene.animationCount: yield scene.animations[x]
#_____________________________
iterator itextures *(scene :ptr Scene) :ptr Texture=
  ## Yields all textures of the given scene
  for x in 0..<scene.textureCount: yield scene.textures[x]
#_____________________________
iterator ilights *(scene :ptr Scene) :ptr Light=
  ## Yields all lights of the given scene
  for x in 0..<scene.lightCount: yield scene.lights[x]
#_____________________________
iterator icameras *(scene :ptr Scene) :ptr Camera=
  ## Yields all cameras of the given scene
  for x in 0..<scene.cameraCount: yield scene.cameras[x]

