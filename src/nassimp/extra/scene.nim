
proc getRoot *(scn :ptr Scene) :ptr Node=  scn.rootNode
  ## Returns the root node of the given scene.

##[
type
  Scene * = object
    flags          *:cint
    rootNode       *:ptr Node

    meshCount      *:cint
    meshes         *:ptr UncheckedArray[PMesh]

    materialCount  *:cint
    materials      *:ptr UncheckedArray[PMaterial]

    animationCount *:cint
    animations     *:ptr UncheckedArray[PAnimation]

    textureCount   *:cint
    textures       *:ptr UncheckedArray[PTexture]

    lightCount     *:cint
    lights         *:ptr UncheckedArray[PLight]

    cameraCount    *:cint
    cameras        *:ptr UncheckedArray[PCamera]
]##

#_____________________________
iterator imeshes *(scene :ptr Scene) :ptr Mesh=
  ## Yields all meshes of the given scene
  for x in 0..<scene.meshCount: yield scene.meshes[x]
#_____________________________
iterator imats *(scene :ptr Scene) :ptr Mesh=
  ## Yields all materials of the given scene
  for x in 0..<scene.materialCount: yield scene.materials[x]
#_____________________________
iterator ianims *(scene :ptr Scene) :ptr Mesh=
  ## Yields all animations of the given scene
  for x in 0..<scene.animationCount: yield scene.animations[x]
#_____________________________
iterator itextures *(scene :ptr Scene) :ptr Mesh=
  ## Yields all textures of the given scene
  for x in 0..<scene.textureCount: yield scene.textures[x]
#_____________________________
iterator ilights *(scene :ptr Scene) :ptr Mesh=
  ## Yields all lights of the given scene
  for x in 0..<scene.lightCount: yield scene.lights[x]
#_____________________________
iterator icameras *(scene :ptr Scene) :ptr Mesh=
  ## Yields all cameras of the given scene
  for x in 0..<scene.cameraCount: yield scene.cameras[x]

