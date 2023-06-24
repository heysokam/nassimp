#:________________________________________________________________
#  nassimp  |  Copyright (C) Ivan Mar (sOkam!)  |  BSD-3-Clause  |
#:________________________________________________________________
# nassimp dependencies
import ../types
import ../procs
import ./convert

#________________________________________
proc getFile *(scene :ptr Scene; matId :int; typ :TextureType; texId :int= 0) :string=
  var tex :String
  case scene.materials[matId].getTexture(typ, texId.cint, path = tex.addr, nil, nil, nil, nil, nil)
  of   ReturnCode.OutOfMemory: raise newException(ImportError, "Tried to get Texture.{typ}.{texId} from material {matId}, but Assimp is OutOfMemory.")
  of   ReturnCode.Failure:     raise newException(ImportError, "Tried to get Texture.{typ}.{texId} from material {matId}, but the operatio failed.")
  of   ReturnCode.Success:     result = $tex
#______________________________
proc getDiffuse      *(scene :ptr Scene; matId :int; texId :int= 0) :string {.inline.}=  scene.getFile(matId, TextureType.diffuse, texId)
proc getSpecular     *(scene :ptr Scene; matId :int; texId :int= 0) :string {.inline.}=  scene.getFile(matId, TextureType.specular, texId)
proc getAmbient      *(scene :ptr Scene; matId :int; texId :int= 0) :string {.inline.}=  scene.getFile(matId, TextureType.ambient, texId)
proc getEmissive     *(scene :ptr Scene; matId :int; texId :int= 0) :string {.inline.}=  scene.getFile(matId, TextureType.emissive, texId)
proc getHeight       *(scene :ptr Scene; matId :int; texId :int= 0) :string {.inline.}=  scene.getFile(matId, TextureType.height, texId)
proc getNormals      *(scene :ptr Scene; matId :int; texId :int= 0) :string {.inline.}=  scene.getFile(matId, TextureType.normals, texId)
proc getShininess    *(scene :ptr Scene; matId :int; texId :int= 0) :string {.inline.}=  scene.getFile(matId, TextureType.shininess, texId)
proc getOpacity      *(scene :ptr Scene; matId :int; texId :int= 0) :string {.inline.}=  scene.getFile(matId, TextureType.opacity, texId)
proc getDisplacement *(scene :ptr Scene; matId :int; texId :int= 0) :string {.inline.}=  scene.getFile(matId, TextureType.displacement, texId)
proc getLightmap     *(scene :ptr Scene; matId :int; texId :int= 0) :string {.inline.}=  scene.getFile(matId, TextureType.lightmap, texId)
proc getReflection   *(scene :ptr Scene; matId :int; texId :int= 0) :string {.inline.}=  scene.getFile(matId, TextureType.reflection, texId)
#______________________________
# Material Checks
proc hasDiffuse      *(mat :ptr Material) :bool {.inline.}=  mat.getTextureCount(TextureType.diffuse) > 0
proc hasSpecular     *(mat :ptr Material) :bool {.inline.}=  mat.getTextureCount(TextureType.specular) > 0
proc hasAmbient      *(mat :ptr Material) :bool {.inline.}=  mat.getTextureCount(TextureType.ambient) > 0
proc hasEmissive     *(mat :ptr Material) :bool {.inline.}=  mat.getTextureCount(TextureType.emissive) > 0
proc hasHeight       *(mat :ptr Material) :bool {.inline.}=  mat.getTextureCount(TextureType.height) > 0
proc hasNormals      *(mat :ptr Material) :bool {.inline.}=  mat.getTextureCount(TextureType.normals) > 0
proc hasShininess    *(mat :ptr Material) :bool {.inline.}=  mat.getTextureCount(TextureType.shininess) > 0
proc hasOpacity      *(mat :ptr Material) :bool {.inline.}=  mat.getTextureCount(TextureType.opacity) > 0
proc hasDisplacement *(mat :ptr Material) :bool {.inline.}=  mat.getTextureCount(TextureType.displacement) > 0
proc hasLightmap     *(mat :ptr Material) :bool {.inline.}=  mat.getTextureCount(TextureType.lightmap) > 0
proc hasReflection   *(mat :ptr Material) :bool {.inline.}=  mat.getTextureCount(TextureType.reflection) > 0

