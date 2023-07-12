#:________________________________________________________________
#  nassimp  |  Copyright (C) Ivan Mar (sOkam!)  |  BSD-3-Clause  |
#:________________________________________________________________
# std dependencies
import std/strformat
import std/strutils
# nassimp dependencies
import ../types as ai
import ../procs
# Extension dependencies
import ./types  as ex
import ./convert
import ./texture


#______________________________
# Material Checks
func has             *(mat :ptr Material; typ :TextureType) :bool {.inline.}=  mat.getTextureCount(typ) > 0
func hasDiffuse      *(mat :ptr Material) :bool {.inline.}=  mat.has(TextureType.diffuse)
func hasSpecular     *(mat :ptr Material) :bool {.inline.}=  mat.has(TextureType.specular)
func hasAmbient      *(mat :ptr Material) :bool {.inline.}=  mat.has(TextureType.ambient)
func hasEmissive     *(mat :ptr Material) :bool {.inline.}=  mat.has(TextureType.emissive)
func hasHeight       *(mat :ptr Material) :bool {.inline.}=  mat.has(TextureType.height)
func hasNormals      *(mat :ptr Material) :bool {.inline.}=  mat.has(TextureType.normals)
func hasShininess    *(mat :ptr Material) :bool {.inline.}=  mat.has(TextureType.shininess)
func hasOpacity      *(mat :ptr Material) :bool {.inline.}=  mat.has(TextureType.opacity)
func hasDisplacement *(mat :ptr Material) :bool {.inline.}=  mat.has(TextureType.displacement)
func hasLightmap     *(mat :ptr Material) :bool {.inline.}=  mat.has(TextureType.lightmap)
func hasReflection   *(mat :ptr Material) :bool {.inline.}=  mat.has(TextureType.reflection)

#________________________________________
func getPath *(mat :ptr Material; typ :TextureType; id :Someinteger= 0) :string=
  ## Returns the file path of the given texture (typ,id) contained in the given Material
  var path :String
  case mat.getTexture(typ, id.cuint, path = path.addr, nil, nil, nil, nil, nil)
  of   ReturnCode.outOfMemory: raise newException(ImportError, &"Tried to get Texture.{typ}.{id} from material {mat.getMatID()}, but Assimp is OutOfMemory.")
  of   ReturnCode.failure:     raise newException(ImportError, &"Tried to get Texture.{typ}.{id} from material {mat.getMatID()}, but the operation failed.")
  of   ReturnCode.success:     result = path.toString
#______________________________
func getDiffusePath      *(mat :ptr Material; texId :int= 0) :string {.inline.}=  mat.getPath(TextureType.diffuse, texId)
func getSpecularPath     *(mat :ptr Material; texId :int= 0) :string {.inline.}=  mat.getPath(TextureType.specular, texId)
func getAmbientPath      *(mat :ptr Material; texId :int= 0) :string {.inline.}=  mat.getPath(TextureType.ambient, texId)
func getEmissivePath     *(mat :ptr Material; texId :int= 0) :string {.inline.}=  mat.getPath(TextureType.emissive, texId)
func getHeightPath       *(mat :ptr Material; texId :int= 0) :string {.inline.}=  mat.getPath(TextureType.height, texId)
func getNormalsPath      *(mat :ptr Material; texId :int= 0) :string {.inline.}=  mat.getPath(TextureType.normals, texId)
func getShininessPath    *(mat :ptr Material; texId :int= 0) :string {.inline.}=  mat.getPath(TextureType.shininess, texId)
func getOpacityPath      *(mat :ptr Material; texId :int= 0) :string {.inline.}=  mat.getPath(TextureType.opacity, texId)
func getDisplacementPath *(mat :ptr Material; texId :int= 0) :string {.inline.}=  mat.getPath(TextureType.displacement, texId)
func getLightmapPath     *(mat :ptr Material; texId :int= 0) :string {.inline.}=  mat.getPath(TextureType.lightmap, texId)
func getReflectionPath   *(mat :ptr Material; texId :int= 0) :string {.inline.}=  mat.getPath(TextureType.reflection, texId)

#______________________________
func getTexture *(
    mat   : ptr Material;
    kind  : TextureType;
    id    : Someinteger;
    scene : ptr Scene;
  ) :TextureInfo=
  ## Returns the texture path or data of the given texture (kind,id) from the given material contained in the input scene.
  ## When the texture is a path,   the result.path field will contain its filepath as a string, and its data will be nil.
  ## When the texture is embedded, the result.data field will contain its contents as a TextureData object
  ## The path is meant to be imported with an external image loading library (like treeform/pixie).
  result.path = mat.getPath(kind, id)
  result.data = nil
  if not result.path.startsWith("*"): return  # Exit early when the texture is just a path.
  # Find the texture data in the textures list
  let tex     = scene.textures[ result.path.parseInt() ]
  result.data = tex.getData()
#______________________________
func getDiffuseTexture      *(mat :ptr Material; id :Someinteger; scene :ptr Scene) :TextureInfo=  mat.getTexture(TextureType.diffuse, id, scene)
func getSpecularTexture     *(mat :ptr Material; id :Someinteger; scene :ptr Scene) :TextureInfo=  mat.getTexture(TextureType.specular, id, scene)
func getAmbientTexture      *(mat :ptr Material; id :Someinteger; scene :ptr Scene) :TextureInfo=  mat.getTexture(TextureType.ambient, id, scene)
func getEmissiveTexture     *(mat :ptr Material; id :Someinteger; scene :ptr Scene) :TextureInfo=  mat.getTexture(TextureType.emissive, id, scene)
func getHeightTexture       *(mat :ptr Material; id :Someinteger; scene :ptr Scene) :TextureInfo=  mat.getTexture(TextureType.height, id, scene)
func getNormalsTexture      *(mat :ptr Material; id :Someinteger; scene :ptr Scene) :TextureInfo=  mat.getTexture(TextureType.normals, id, scene)
func getShininessTexture    *(mat :ptr Material; id :Someinteger; scene :ptr Scene) :TextureInfo=  mat.getTexture(TextureType.shininess, id, scene)
func getOpacityTexture      *(mat :ptr Material; id :Someinteger; scene :ptr Scene) :TextureInfo=  mat.getTexture(TextureType.opacity, id, scene)
func getDisplacementTexture *(mat :ptr Material; id :Someinteger; scene :ptr Scene) :TextureInfo=  mat.getTexture(TextureType.displacement, id, scene)
func getLightmapTexture     *(mat :ptr Material; id :Someinteger; scene :ptr Scene) :TextureInfo=  mat.getTexture(TextureType.lightmap, id, scene)
func getReflectionTexture   *(mat :ptr Material; id :Someinteger; scene :ptr Scene) :TextureInfo=  mat.getTexture(TextureType.reflection, id, scene)


func getData *(mat :ptr Material; id :Someinteger; scene :ptr Scene) :MaterialData=
  ## Returns all texture/material data of the given `mat` contained in the input scene.
  new result
  result.id = id
  for typ in TextureType:
    if not mat.has(typ): continue             # Skip adding this type of texture if the material doesn't have any
    echo mat.getMatID()," : ", typ, " -> ",mat.has(typ)
    for tex in 0..<mat.getTextureCount(typ):  # Create a sequence with all textures contained in the material
      result.tex[typ].add mat.getTexture(typ, tex, scene)





##[ TODO: Get other the other texture properties, like mapping, uv, blend, op, mapMode, flags
# proc getTexture *(
#     material : ptr Material;
#     kind     : TextureType;
#     index    : cuint;
#     path     : ptr String;
#     mapping  : ptr TextureMapping = nil;
#     uvIndex  : ptr cuint          = nil;
#     blend    : ptr cfloat         = nil;
#     op       : ptr TextureOp      = nil;
#     mapMode  : ptr TextureMapMode = nil;
#     flags    : ptr TextureFlags   = nil;
#   ) :ReturnCode {.importc: "aiGetMaterialTexture".}
# #_____________________________
# proc getMaterialColor *(
#     material : ptr Material;
#     name     : cstring;
#     typ      : cuint;
#     index    : cuint;
#     color    : ptr ColorRGB;
#   ) :ReturnCode {.importc: "aiGetMaterialColor".}
# #_____________________________
# proc getTextureCount *(
#     material : ptr Material;
#     kind     : TextureType;
#   ) :uint32 {.importc: "aiGetMaterialTextureCount".}
# #_____________________________
# proc getMaterialFloatArray *(
#     material : ptr Material;
#     key      : cstring;
#     typ      : cuint;
#     index    : cuint = 0;
#     res      : ptr cfloat;
#     max      : ptr cuint = nil;
#   ) :ReturnCode {.importc: "aiGetMaterialFloatArray".}

# type PropertyType *{.pure, size: sizeof(cint).} = enum
#   Float = 0x1, String = 0x3, Integer = 0x4, Buffer = 0x5
# type MaterialProperty * = object
#   key        *:String
#   semantic   *:cint
#   index      *:cint
#   dataLength *:cint
#   kind       *:PropertyType
#   data       *:UncheckedArray[char]
# #_____________________________
# type Material *{.pure.}= object
#   properties    *:ptr UncheckedArray[ptr MaterialProperty]
#   propertyCount *:cuint
#   numAllocated  *:cuint
]##
