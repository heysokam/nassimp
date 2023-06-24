#:________________________________________________________________
#  nassimp  |  Copyright (C) Ivan Mar (sOkam!)  |  BSD-3-Clause  |
#:________________________________________________________________

#_______________________________________
# Nim Exceptions
type ImportError = object of IOError


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
# Metadata
#_____________________________
type MetadataType *{.pure, size: sizeof(cint).}= enum
  Bool, Int32, Uint64, Float, Double, String, Vector3, Metadata, Int64, Uint32, Max
type MetadataEntry * = object
  typ  *:MetadataType
  data *:pointer
#_____________________________
type Metadata * = object
  numProperties  *:cuint              ## Length of the mKeys and mValues arrays, respectively
  keys           *:ptr String         ## Arrays of keys, may not be NULL. Entries in this array may not be NULL as well.
  values         *:ptr MetadataEntry  ## Arrays of values, may not be NULL. Entries in this array may be NULL if the corresponding property key has no assigned value.

#_______________________________________
# Logging
#_____________________________
type DefaultLogStream *{.pure, size: sizeof(int32)..}= enum
  Fil      = 0x1, ## Stream the log to a file
  Stdout   = 0x2, ## Stream the log to std::cout
  Stderr   = 0x4, ## Stream the log to std::cerr
  Debugger = 0x8, ## MSVC only: Stream log to the debugger (on OutputDebugString from the Win32 SDK)
type LogStreamCallback* = proc (a1 :cstring; a2 :cstring)
type LogStream *{.bycopy.} = object
  callback *:LogStreamCallback
  user     *:cstring


#_______________________________________
# Node
#_____________________________
type Node *{.pure.}= object
  name           *:String
  transformation *:Matrix4
  parent         *:ptr Node
  childrenCount  *:cint
  children       *:ptr UncheckedArray[ptr Node]
  meshCount      *:cint
  meshes         *:ptr UncheckedArray[cint]
  metaData       *:ptr Metadata


#_______________________________________
# Mesh
#_____________________________
type Face * = object
  indexCount *:cint
  indices    *:ptr UncheckedArray[cint]
#_____________________________
type VertexWeight * = object
  vertexID     *:cint
  weight       *:cfloat
type Bone * = object
  name         *:String
  numWeights   *:cint
  weights      *:ptr UncheckedArray[VertexWeight]
  offsetMatrix *:Matrix4
#_____________________________
const MaxColors    = 0x8 # MAX_NUMBER_OF_COLOR_SETS
const MaxTexCoords = 0x8 # MAX_NUMBER_OF_TEXTURECOORDS
#_____________________________
type PrimitiveType *{.pure, size: sizeof(cint).} = enum
  point = 0x1, line = 0x2, triangle = 0x4, polygon = 0x8
#_____________________________
type Mesh *{.pure.}= object
  primitiveTypes  *:cint
  vertexCount     *:cint
  faceCount       *:cint
  vertices        *:ptr UncheckedArray[Vector3]
  normals         *:ptr UncheckedArray[Vector3]
  tangents        *:ptr UncheckedArray[Vector3]
  bitTangents     *:ptr UncheckedArray[Vector3]
  colors          *:array[0..MaxColors-1, ptr Color]
  texCoords       *:array[0..MaxTexCoords-1, ptr Vector3]
  numUVcomponents *:array[0..MaxTexCoords-1, cint]
  faces           *:ptr UncheckedArray[Face]
  boneCount       *:cint
  bones           *:ptr UncheckedArray[ptr Bone]
  materialIndex   *:cint
  name            *:String
  anmMeshCount    *:cint
  animMeshes      *:pointer ## ptr ptr AnimMesh


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
  data       *:ptr char
#_____________________________
type Material *{.pure.}= object
  properties    *:ptr ptr MaterialProperty
  propertyCount *:cint
  numAllocated  *:cint


#_______________________________________
# Animation
#_____________________________
type AnimBehavior *{.pure, size: sizeof(cint).} = enum
  default, constant, linear, repeat
#_____________________________
type NodeAnim    *{.pure.}= object
  nodeName         *:String
  positionKeyCount *:cint
  positionKeys     *:ptr VectorKey
  rotationKeyCount *:cint
  rotationKeys     *:ptr QuatKey
  scalingKeyCount  *:cint
  scalingKeys      *:ptr VectorKey
  preState         *:AnimBehavior
  posState         *:AnimBehavior
#_____________________________
type MeshKey * = object
  time  *:cdouble
  value *:cint
type MeshAnim *{.pure.}= object
  name     *:String
  keyCount *:cint
  keys     *:ptr MeshKey
#_____________________________
type Animation    *{.pure.}= object
  name             *:String
  duration         *:cdouble
  ticksPerSec      *:cdouble
  channelCount     *:cint
  channels         *:ptr ptr NodeAnim
  meshChannelCount *:cint
  meshChannels     *:ptr ptr MeshAnim


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
# Scene
#_____________________________
type Scene *{.pure.}= object
  flags          *:cint
  rootNode       *:ptr Node
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
  name           *:String
  numSkeletons   *:cuint
  skeletons      *:ptr ptr Skeleton


#_______________________________________
# Import Process
#_____________________________
type ImportProcess *{.pure.}= enum
  calcTangentSpace
  joinIdenticalVerts
  makeLeftHanded
  triangulate
  removeComponent
  genNormals
  genSmoothNormals
  splitLargeMeshes
  preTransformVerts
  limitBoneWeights
  validateDataStructure
  improveCacheLocality
  removeRedundantMaterials
  fixInfacingNormals
  sortByPType
  findDegenerates
  findInvalidData
  genUvCoords
  transformUvCoords
  findInstances
  optimizeMesh
  omptimizeGraph
  flipUvs
  flipWindingOrder
#_____________________________
const ProcessLut * = [
  calcTangentSpace         : 0x00000001.cint,
  joinIdenticalVerts       : 0x00000002.cint,
  makeLeftHanded           : 0x00000004.cint,
  triangulate              : 0x00000008.cint,
  removeComponent          : 0x00000010.cint,
  genNormals               : 0x00000020.cint,
  genSmoothNormals         : 0x00000040.cint,
  splitLargeMeshes         : 0x00000080.cint,
  preTransformVerts        : 0x00000100.cint,
  limitBoneWeights         : 0x00000200.cint,
  validateDataStructure    : 0x00000400.cint,
  improveCacheLocality     : 0x00000800.cint,
  removeRedundantMaterials : 0x00001000.cint,
  fixInfacingNormals       : 0x00002000.cint,
  sortByPType              : 0x00008000.cint,
  findDegenerates          : 0x00010000.cint,
  findInvalidData          : 0x00020000.cint,
  genUvCoords              : 0x00040000.cint,
  transformUvCoords        : 0x00080000.cint,
  findInstances            : 0x00100000.cint,
  optimizeMesh             : 0x00200000.cint,
  omptimizeGraph           : 0x00400000.cint,
  flipUvs                  : 0x00800000.cint,
  flipWindingOrder         : 0x01000000.cint,
  ] # << ProcessLut[ ... ]
#_____________________________
const ConvertToLeftHanded * = {
  makeLeftHanded,
  flipUvs,
  flipWindingOrder
  } # << ConvertToLeftHanded{ ... }
#_____________________________
const TargetRealtimeFast * = {
  calcTangentSpace,
  genNormals,
  joinIdenticalVerts,
  triangulate,
  genUvCoords,
  sortByPType,
  } # TargetRealtimeFast{ ... }
#_____________________________
const TargetRealtimeQuality * = {
  calcTangentSpace,
  genSmoothNormals,
  joinIdenticalVerts,
  improveCacheLocality,
  limitBoneWeights,
  removeRedundantMaterials,
  splitLargeMeshes,
  triangulate,
  genUvCoords,
  sortByPType,
  findDegenerates,
  findInvalidData,
  } # TargetRealtimeQuality{ ... }
#_____________________________
const TargetRealtimeMaxQuality * = TargetRealtimeQuality + {
  findInstances,
  validateDataStructure,
  optimizeMesh,
  } # << TargetRealtimeMaxQuality{ ... }

