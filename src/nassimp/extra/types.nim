#:________________________________________________________________
#  nassimp  |  Copyright (C) Ivan Mar (sOkam!)  |  BSD-3-Clause  |
#:________________________________________________________________
# nassimp dependencies
from ../types as ai import nil

#_______________________________________
# Nim Exceptions
type ImportError * = object of IOError

#_______________________________________
type ColorRGB  * = tuple[r, g, b: float32]
type Color     * = tuple[r, g, b, a: float32]
type Vector2   * = tuple[x, y: float32]
type Vector3   * = tuple[x, y, z: float32]
type UVector2  * = tuple[x, y: uint32]     # Extension, for better management of sizes
type UVector3  * = tuple[x, y, z: uint32]  # Extension, for better management of face indices

#_______________________________________
# Textures
type TextureData * = ref object
  format  *:string
  size    *:UVector2
  pixels  *:seq[ai.Texel]
#_______________________________________
type TextureInfo * = ref object
  path  *:string
  data  *:TextureData
type TextureList * = array[ai.TextureType, seq[TextureInfo]]

#_______________________________________
# Materials
type MaterialData * = ref object
  id   *:int
  tex  *:TextureList

#_______________________________________
# Meshes and Models
type MeshData * = ref object
  primitives  *:ai.PrimitiveTypes ## Types of primitives contained in the mesh
  name        *:string            ## Mesh name  (as taken from ??)
  inds        *:seq[UVector3]     ## Face indices
  pos         *:seq[Vector3]      ## Vertex Positions
  colors      *:seq[Color]        ## Vertex colors
  uvs         *:seq[Vector2]      ## Texture coordinates
  norms       *:seq[Vector3]      ## Normal vectors
  tans        *:seq[Vector3]      ## Tangents
  bitans      *:seq[Vector3]      ## Bitangents
  material    *:MaterialData
  # bones       *:seq[ai.Bone]      ## Mesh bones
  # animMeshes  *:seq[ai.AnimMesh]  ## Vertex animation data
  # TODO: Skeletal Animations (animation,skeleton)
#_______________________________________
type ModelData * = seq[MeshData]  # Models are a list of meshes

#_______________________________________
# Scene: Cameras
type CameraData * = ref object
  name   *:string
  pos    *:Vector3
  up     *:Vector3
  lookat *:Vector3
  fovx   *:float32
  near   *:float32
  far    *:float32
  ratio  *:float32
  width  *:float32 # OrthographicWidth
#_______________________________________
# Scene: Lights
type LightData * = ref object
  kind                 *:ai.LightSource
  name                 *:string
  position             *:Vector3
  direction            *:Vector3
  attenuationConst     *:float32
  attenuationLinear    *:float32
  attenuationQuadratic *:float32
  colorDiffuse         *:ColorRGB
  colorSpecular        *:ColorRGB
  colorAmbient         *:ColorRGB
  innerCone            *:float32
  outerCone            *:float32
#_______________________________________
# Scene: All Data
type SceneData * = ref object
  models *:seq[ModelData]
  cams   *:seq[CameraData]
  lights *:seq[LightData]

