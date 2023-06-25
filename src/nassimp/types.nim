#:________________________________________________________________
#  nassimp  |  Copyright (C) Ivan Mar (sOkam!)  |  BSD-3-Clause  |
#:________________________________________________________________

#_______________________________________
# Nim Exceptions
type ImportError * = object of IOError


#_______________________________________
const MATKEY_COLOR_DIFFUSE  * = "$clr.diffuse"
const MATKEY_COLOR_AMBIENT  * = "$clr.ambient"
const MATKEY_COLOR_SPECULAR * = "$clr.specular"
const MATKEY_SHININESS      * = "$mat.shininess"


#_______________________________________
# General Purpose
#_____________________________
const MaxStringLen = 1024
type String * = object
  length *:cuint
  data   *:array[0..MaxStringLen-1, char]
type Texel     * = tuple[b, g, r, a: byte]
type ColorRGB  * = tuple[r, g, b: cfloat]
type Color     * = tuple[r, g, b, a: cfloat]
type Vector2   * = tuple[x, y: cfloat]
type Vector3   * = tuple[x, y, z: cfloat]
type VectorKey *{.pure.}= object
  time  *:cdouble
  value *:Vector3
type Quat * = tuple[w, x, y, z: cfloat]
type QuatKey * = object
  time  *:cdouble
  value *:Quat
type Matrix4 * = array[0..15, cfloat]
type Matrix3 * = array[0..8, cfloat]
type Plane * = object
  a *:cfloat
  b *:cfloat
  c *:cfloat
  d *:cfloat
type ReturnCode *{.pure, size: sizeof(cint).}= enum
  outOfMemory = -3, failure = -1, success = 0

#_______________________________________
# Logging
#_____________________________
type DefaultLogStream *{.pure, size: sizeof(int32).}= enum
  Fil      = 0x1, ## Stream the log to a file
  Stdout   = 0x2, ## Stream the log to std::cout
  Stderr   = 0x4, ## Stream the log to std::cerr
  Debugger = 0x8, ## MSVC only: Stream log to the debugger (on OutputDebugString from the Win32 SDK)
type LogStreamCallback* = proc (a1 :cstring; a2 :cstring)
type LogStream *{.bycopy.} = object
  callback *:LogStreamCallback
  user     *:cstring


#_______________________________________
# Metadata
#_____________________________
type MetadataType *{.pure, size: sizeof(cint).}= enum
  Bool, Int32, Uint64, Float, Double, String, Vector3, Metadata, Int64, Uint32, Max
type MetadataEntry * = object
  typ  *:MetadataType
  data *:pointer
#_____________________________
type Metadata * = object
  numProperties  *:cuint                          ## Length of the mKeys and mValues arrays, respectively
  keys           *:UncheckedArray[String]         ## Arrays of keys, may not be NULL. Entries in this array may not be NULL as well.
  values         *:UncheckedArray[MetadataEntry]  ## Arrays of values, may not be NULL. Entries in this array may be NULL if the corresponding property key has no assigned value.


#_______________________________________
# Node
#_____________________________
type Node *{.pure.}= object
  name           *:String
  transformation *:Matrix4
  parent         *:ptr Node
  childrenCount  *:cuint
  children       *:ptr UncheckedArray[ptr Node]
  meshCount      *:cuint
  meshes         *:ptr UncheckedArray[cint]
  metaData       *:ptr Metadata


#_______________________________________
# Mesh
#_____________________________
type Face * = object
  indexCount *:cuint
  indices    *:ptr UncheckedArray[cint]
#_____________________________
type VertexWeight * = object
  vertexID     *:cint
  weight       *:cfloat
type Bone * = object
  name         *:String
  numWeights   *:cuint
  weights      *:ptr UncheckedArray[VertexWeight]
  offsetMatrix *:Matrix4
#_____________________________
const MaxColors    = 0x8 # MAX_NUMBER_OF_COLOR_SETS
const MaxTexCoords = 0x8 # MAX_NUMBER_OF_TEXTURECOORDS
#_____________________________
type PrimitiveType *{.pure, size: sizeof(cint).} = enum
  point, line, triangle, polygon
type PrimitiveTypes * = set[PrimitiveType]
#_____________________________
type AnimMesh * = object
  name        *:String                                     ## Anim Mesh name
  vertices    *:UncheckedArray[ptr Vector3]                ## Replacement for aiMesh::mVertices.
  normals     *:UncheckedArray[ptr Vector3]                ## Replacement for aiMesh::mNormals.
  tangents    *:UncheckedArray[ptr Vector3]                ## Replacement for aiMesh::mTangents.
  bitangents  *:UncheckedArray[ptr Vector3]                ## Replacement for aiMesh::mBitangents.
  colors      *:ptr array[0..MaxColors-1, ptr Color]       ## Replacement for aiMesh::mColors
  texCoords   *:ptr array[0..MaxTexCoords-1, ptr Vector3]  ## Replacement for aiMesh::mTextureCoords
  numVertices *:cuint                                      ## The number of vertices in the aiAnimMesh, and thus the length of all the member arrays. This has always the same value as the mNumVertices property in the corresponding aiMesh.
  weight      *:cfloat                                     ## Weight of the AnimMesh.
#_____________________________
type Mesh *{.pure.}= object
  primitiveTypes  *:PrimitiveTypes
  vertexCount     *:cuint
  faceCount       *:cuint
  vertices        *:ptr UncheckedArray[Vector3]
  normals         *:ptr UncheckedArray[Vector3]
  tangents        *:ptr UncheckedArray[Vector3]
  bitTangents     *:ptr UncheckedArray[Vector3]
  colors          *:array[0..MaxColors-1, ptr Color]
  texCoords       *:array[0..MaxTexCoords-1, ptr Vector3]
  numUVcomponents *:array[0..MaxTexCoords-1, cint]
  faces           *:ptr UncheckedArray[Face]
  boneCount       *:cuint
  bones           *:ptr UncheckedArray[ptr Bone]
  materialIndex   *:cuint
  name            *:String
  animMeshCount   *:cuint
  animMeshes      *:ptr UncheckedArray[ptr AnimMesh]


#_______________________________________
# Material
#_____________________________
type PropertyType *{.pure, size: sizeof(cint).} = enum
  Float = 0x1, String = 0x3, Integer = 0x4, Buffer = 0x5
type MaterialProperty * = object
  key        *:String
  semantic   *:cint
  index      *:cint
  dataLength *:cint
  kind       *:PropertyType
  data       *:UncheckedArray[char]
#_____________________________
type Material *{.pure.}= object
  properties    *:ptr UncheckedArray[ptr MaterialProperty]
  propertyCount *:cuint
  numAllocated  *:cuint


#_______________________________________
# Animation
#_____________________________
type AnimBehavior *{.pure, size: sizeof(cint).} = enum
  default, constant, linear, repeat
#_____________________________
type NodeAnim    *{.pure.}= object
  nodeName         *:String
  positionKeyCount *:cuint
  positionKeys     *:UncheckedArray[VectorKey]
  rotationKeyCount *:cuint
  rotationKeys     *:UncheckedArray[QuatKey]
  scalingKeyCount  *:cuint
  scalingKeys      *:UncheckedArray[VectorKey]
  preState         *:AnimBehavior
  posState         *:AnimBehavior
#_____________________________
type MeshKey * = object
  time  *:cdouble
  value *:cint
type MeshAnim *{.pure.}= object
  name     *:String
  keyCount *:cuint
  keys     *:UncheckedArray[MeshKey]
#_____________________________
type Animation    *{.pure.}= object
  name             *:String
  duration         *:cdouble
  ticksPerSec      *:cdouble
  channelCount     *:cuint
  channels         *:ptr UncheckedArray[ptr NodeAnim]
  meshChannelCount *:cuint
  meshChannels     *:ptr UncheckedArray[ptr MeshAnim]


#_______________________________________
# Texture
#_____________________________
type TextureMapMode *{.pure, size: sizeof(cint).} = enum
  wrap, clamp, decal, mirror
#_____________________________
type TextureOp *{.pure, size: sizeof(cint).} = enum
  Multiply, Add, Subtract, Divide, SmoothAdd, SignedAdd
#_____________________________
type TextureMapping *{.pure, size: sizeof(cint).} = enum
  UV, sphere, cylinder, box, plane, other
#_____________________________
type TextureType *{.pure, size: sizeof(cint).} = enum
  none
  diffuse, specular, ambient, emissive,
  height, normals, shininess, opacity,
  displacement, lightmap, reflection, unknown
#_____________________________
type Texture    * = object
  width         *:cint
  height        *:cint
  achFormatHint *:array[0..3, cchar]
  pcData        *:ptr Texel


#_______________________________________
# Light
#_____________________________
type LightSource *{.pure, size: sizeof(cint).}= enum
  undefined, directional, point, spot
type Light * = object
  name                 *:String
  kind                 *:LightSource
  position             *:Vector3
  direction            *:Vector3
  attenuationConst     *:cfloat
  attenuationLinear    *:cfloat
  attenuationQuadratic *:cfloat
  colorDiffuse         *:ColorRGB
  colorSpecular        *:ColorRGB
  colorAmbient         *:ColorRGB
  innerCone            *:cfloat
  outerCone            *:cfloat


#_______________________________________
# Camera
#_____________________________
type Camera * = object
  name   *:String
  pos    *:Vector3
  up     *:Vector3
  lookat *:Vector3
  fovx   *:cfloat
  near   *:cfloat
  far    *:cfloat
  ratio  *:cfloat
  width  *:cfloat # OrthographicWidth


#_______________________________________
# Armature/Skeleton
#_____________________________
type Skeleton * = object
  name      *:String                        ## The name of the skeleton instance.
  boneCount *:cuint                         ## The number of bones in the skeleton.
  bones     *:ptr UncheckedArray[ptr Bone]  ## The bone instance in the skeleton.


#_______________________________________
# Import Process
#_____________________________
type Process *{.pure, size: sizeof(cint).}= enum
  calcTangentSpace          ## Calculates the tangents and bitangents for the imported meshes. Does nothing if a mesh does not have normals.
  joinIdenticalVerts        ## Required for Indexed geometry. Joins identical vertex data sets within all imported meshes. Each mesh will contain unique vertices, so a vertex may be used by multiple faces.
  makeLeftHanded            ## Converts coordinats to LeftHanded (wgpu, d3d, etc. OpenGL is RightHanded, it does not require this)
  triangulate               ## Triangulates all faces of all meshes. By default the imported mesh data might contain faces with more than 3 indices.
  removeComponent           ## Removes all components set in the RemoveComponent configuration flags. Default is none.
  genNormals                ## Generates normals for all faces of all meshes. This is ignored if normals are already there at the time this flag is evaluated.
  genSmoothNormals          ## Generates smooth normals for all faces of all meshes. This is ignored if normals are already there at the time this flag is evaluated.
  splitLargeMeshes          ## Splits large meshes into smaller sub-meshes. This is quite useful where the number of triangles which can be processed in a single draw-call is limited by the video driver/hardware.
  preTransformVerts         ## Removes the node graph and pre-transforms all vertices with the local transformation matrices of their nodes. Animations are removed. The output scene will contain a root node with children, each one referencing one mesh, and each mesh referencing one material. You can simply render the resulting meshes in order. This step is intended for applications without a scenegraph. 
  limitBoneWeights          ## Limits the number of bones simultaneously affecting a single vertex to a maximum value. Useful for skinning in hardware.
  validateDataStructure     ## Validates the imported scene data structure. Makes sure that all indices are valid, all animations and bones are linked correctly, all material references are correct .. etc.
  improveCacheLocality      ## Reorders triangles for better vertex cache locality. It tries to improve the ACMR (average post-transform vertex cache miss ratio) for all meshes. Runs in O(n) and is based on the 'tipsify' algorithm.
  removeRedundantMaterials  ## Searches for redundant/unreferenced materials and removes them. Ignores name differences. Useful in combination with the #aiProcess_PretransformVertices and #aiProcess_OptimizeMeshes flags, that join small meshes with equal characteristics, but can't do their work if two meshes have different materials.
  fixInfacingNormals        ## Tries to determine which meshes have normal vectors that are facing inwards and inverts them. Generally recommended, although the result is not always correct.
  sortByPType               ## Splits meshes with more than one primitive type in homogeneous sub-meshes. Used to exclude lines and points, which are rarely used, from the import.
  findDegenerates           ## Searches all meshes for degenerate primitives and converts them to proper lines or points. A face is 'degenerate' if one or more of its points are identical.
  findInvalidData           ## Searches all meshes for invalid data, such as zeroed normal vectors or invalid UV coords and removes/fixes them, to get rid of common exporter errors. Especially useful for invalid normals, which could be recomputed. It will also remove meshes that are infinitely small and reduce animation tracks consisting of hundreds if redundant keys to a single key.
  genUvCoords               ## Converts non-UV mappings (such as spherical or cylindrical mapping) to proper texture coordinate channels. Most apps only support UV mapping.
  transformUvCoords         ## Applies per-texture UV transformations and bakes them into stand-alone vtexture coordinate channels. Most apps do not support UV transformations.
  findInstances             ## Searches for duplicate meshes and replaces them with references to the first mesh. Workaround for file formats that don't support instanced meshes, so exporters duplicate them.
  optimizeMesh              ## Reduces the number of meshes. This will reduce the number of draw calls. Very effective optimization, recommended to be combined with #aiProcess_OptimizeGraph
  optimizeGraph             ## Optimizes the scene hierarchy. Nodes without animations, bones, lights or cameras assigned are collapsed and joined.
  flipUvs                   ## Flips all UV coordinates along the y-axis and adjusts material settings and bitangents accordingly.
  flipWindingOrder          ## Adjusts the output to be CW. The default is counter clockwise (CCW).
type ProcessFlags * = set[Process]
type API *{.pure.}= enum wgpu, OpenGL
type WindingOrder * = enum CCW, CW  ## Assimp defaults to CCW when not explicitly flipped with Process.flipWindingOrder
#_____________________________
template defaultBase *(_:typedesc[Process]) :ProcessFlags=  {
  Process.calcTangentSpace, Process.joinIdenticalVerts, Process.triangulate, Process.removeComponent, Process.genNormals, Process.genSmoothNormals, Process.splitLargeMeshes,
  Process.validateDataStructure, Process.improveCacheLocality, Process.removeRedundantMaterials, Process.fixInfacingNormals, Process.sortByPType, Process.findDegenerates,
  Process.findInvalidData, Process.genUvCoords, Process.transformUvCoords, Process.findInstances, Process.optimizeMesh, Process.omptimizeGraph,   } # << ProcessLut
func default *(_:typedesc[Process];
    api    = API.wgpu;
    worder = WindingOrder.CCW;
  ) :ProcessFlags=
  case api
  of API.OpenGL: result = Process.defaultBase
  of API.wgpu:   result = Process.defaultBase + {Process.makeLeftHanded, Process.flipUvs}
  if worder == WindingOrder.CW: result.incl Process.flipWindingOrder
#_____________________________
template leftHanded         *(_:typedesc[Process]) :ProcessFlags=  { Process.makeLeftHanded, Process.flipUvs, Process.flipWindingOrder,  }
template realtimeFast       *(_:typedesc[Process]) :ProcessFlags=  { Process.calcTangentSpace, Process.genNormals, Process.joinIdenticalVerts, Process.triangulate, Process.genUvCoords, Process.sortByPType, }
template realtimeQuality    *(_:typedesc[Process]) :ProcessFlags=  { Process.calcTangentSpace, Process.genSmoothNormals, Process.joinIdenticalVerts, Process.improveCacheLocality, Process.limitBoneWeights, Process.removeRedundantMaterials, Process.splitLargeMeshes, Process.triangulate, Process.genUvCoords, Process.sortByPType, Process.findDegenerates, Process.findInvalidData, }
template realtimeQualityMax *(_:typedesc[Process]) :ProcessFlags=  Process.realtimeQuality + { Process.findInstances, Process.validateDataStructure, Process.optimizeMesh, } # << TargetRealtimeMaxQuality{ ... }
template all                *(_:typedesc[Process]) :ProcessFlags=  { Process.low .. Process.high }
template none               *(_:typedesc[Process]) :ProcessFlags=  {}


#_______________________________________
# Scene
#_____________________________
type SceneFlag *{.pure, size: sizeof(cuint).}= enum
  incomplete     ## The scene data structure that was imported is not complete.
  validated      ## The validation process was successful.
  validationWRN  ## The validation process found issues (texture that does not exist is referenced, etc)
  nonVerboseFmt  ## Process.joinIdenticalVerts set vertices to be nonVerbose. Verbose means all vertices are unique and not referenced by more than one face.
  terrain        ## The scene is composed only of height-map terrain data.
  allowShared    ## The scene data can be shared between structures. (eg: one vertex in few faces)
type SceneFlags * = set[SceneFlag]
type Scene *{.pure.}= object
  flags          *:SceneFlags
  rootNode       *:ptr Node
  meshCount      *:cuint
  meshes         *:ptr UncheckedArray[ptr Mesh]
  materialCount  *:cuint
  materials      *:ptr UncheckedArray[ptr Material]
  animationCount *:cuint
  animations     *:ptr UncheckedArray[ptr Animation]
  textureCount   *:cuint
  textures       *:ptr UncheckedArray[ptr Texture]
  lightCount     *:cuint
  lights         *:ptr UncheckedArray[ptr Light]
  cameraCount    *:cuint
  cameras        *:ptr UncheckedArray[ptr Camera]
  metaData       *:ptr Metadata
  name           *:String
  skeletonCount  *:cuint
  skeletons      *:ptr UncheckedArray[ptr Skeleton]

