#:________________________________________________________________
#  nassimp  |  Copyright (C) Ivan Mar (sOkam!)  |  BSD-3-Clause  |
#:________________________________________________________________
# nassimp dependencies
import ../types as ai
# Extension dependencies
import ./types  as ex
import ./convert
import ./node
import ./mesh
import ./material


#_________________________________________________
# Data iterators
#_____________________________
iterator imeshes *(scene :ptr Scene) :ptr Mesh=
  ## Yields all meshes of the given scene
  for x in 0..<scene.meshCount: yield scene.meshes[x]
#_____________________________
iterator imaterials *(scene :ptr Scene) :ptr Material=
  ## Yields all materials of the given scene
  for x in 0..<scene.materialCount: yield scene.materials[x]
#_____________________________
iterator ianimations *(scene :ptr Scene) :ptr Animation=
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
#_____________________________
iterator iskeletons *(scene :ptr Scene) :ptr Skeleton=
  ## Yields all cameras of the given scene
  for x in 0..<scene.skeletonCount: yield scene.skeletons[x]


#_________________________________________________
# Data checks
#_____________________________
func hasMaterials  *(scn :ptr Scene) :bool=  scn.materialCount  > 0 and not scn.materials.isNil
func hasAnimations *(scn :ptr Scene) :bool=  scn.animationCount > 0 and not scn.animations.isNil
func hasTextures   *(scn :ptr Scene) :bool=  scn.textureCount   > 0 and not scn.textures.isNil
func hasLights     *(scn :ptr Scene) :bool=  scn.lightCount     > 0 and not scn.lights.isNil
func hasCameras    *(scn :ptr Scene) :bool=  scn.cameraCount    > 0 and not scn.cameras.isNil
func hasSkeletons  *(scn :ptr Scene) :bool=  scn.skeletonCount  > 0 and not scn.skeletons.isNil


#_________________________________________________
# General Fields
#_____________________________
proc getRoot *(scn :ptr Scene) :ptr Node=  scn.rootNode
  ## Returns the root node of the given scene.
proc hasRoot *(scn :ptr Scene) :bool=  scn.getRoot != nil
  ## Returns true if the scene has a root node.
proc getName *(scn :ptr Scene) :string=  scn.name.toString
  ## Returns the name of the given scene.
proc getMetadata *(scn :ptr Scene) :ptr Metadata=  scn.metaData
#_________________________________________________
# Flags field
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
#_________________________________________________
# Data Fields
#_____________________________
# Get all data at once
proc getMaterials *(scn :ptr Scene) :seq[Material]=
  ## Returns a copy of all materials of the given scene
  for mat in scn.imaterials: result.add mat[]
proc getAnimations *(scn :ptr Scene) :seq[Animation]=
  ## Returns a copy of all animations of the given scene
  for anim in scn.ianimations: result.add anim[]
proc getTextures *(scn :ptr Scene) :seq[Texture]=
  ## Returns a copy of all textures of the given scene
  for tex in scn.itextures: result.add tex[]
proc getLights *(scn :ptr Scene) :seq[Light]=
  ## Returns a copy of all lights of the given scene
  for light in scn.ilights: result.add light[]
proc getCameras *(scn :ptr Scene) :seq[Camera]=
  ## Returns a copy of all cameras of the given scene
  for cam in scn.icameras: result.add cam[]
proc getSkeletons *(scn :ptr Scene) :seq[Skeleton]=
  ## Returns a copy of all skeletons of the given scene
  for skel in scn.iskeletons: result.add skel[]
#_____________________________
# Get data by id
proc getMaterial *(scn :ptr Scene; id :SomeInteger) :ptr Material=  scn.materials[id]
  ## Retrieves the material with the given id from the scene data
proc getAnimation  *(scn :ptr Scene; id :SomeInteger) :ptr Animation=  scn.animations[id]
  ## Retrieves the animation with the given id from the scene data
proc getTexture *(scn :ptr Scene; id :SomeInteger) :ptr Texture=  scn.textures[id]
  ## Retrieves the texture with the given id from the scene data
proc getLight *(scn :ptr Scene; id :SomeInteger) :ptr Light=  scn.lights[id]
  ## Retrieves the light with the given id from the scene data
proc getCamera *(scn :ptr Scene; id :SomeInteger) :ptr Camera=  scn.cameras[id]
  ## Retrieves the camera with the given id from the scene data
proc getSkeleton *(scn :ptr Scene; id :SomeInteger) :ptr Skeleton=  scn.skeletons[id]
  ## Retrieves the skeleton with the given id from the scene data

#_____________________________
# Get nim-only data
func getCamerasData *(scn :ptr Scene) :seq[CameraData]=
  ## Returns all cameras contained in the given scene, as a sequence of Data objects that only contain Nim types
  for cam in scn.icameras: result.add cam.toData()
#_____________________________
func getLightsData *(scn :ptr Scene) :seq[LightData]=
  ## Returns all lights contained in the given scene, as a sequence of Data objects that only contain Nim types
  for light in scn.ilights: result.add light.toData()
#_____________________________
func getModelData  *(scn :ptr Scene; node :ptr Node; recursive=false) :ModelData=
  ## Returns the ModelData contained in the given node, accessing its data from the given scene
  ## Treats the input node as a single model, and all its meshes will be moved to its root.
  ## recursive=true will also add to the result the data of all meshes contained in its children and subchildrens.
  for id in node.getMeshIDs( recursive=recursive ):
    result.add scn.meshes[id].getData()
  for mesh in result:
    let id = mesh.material.id
    mesh.material = scn.getMaterial( id ).getData( id, scn )  # Query the material data with its id from the scene
  # TODO: Animations
  # TODO: Skeletons
#_____________________________
func getModelsData *(scn :ptr Scene; modelNodes :seq[ptr Node]) :seq[ModelData]=
  ## Returns a list of all ModelData objects contained in the given node, accessing their data from the given scene
  ## Treats the input node as a separate list of models.
  for node in modelNodes: result.add scn.getModelData(node, recursive=true)

