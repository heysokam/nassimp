#:________________________________________________________________
#  nassimp  |  Copyright (C) Ivan Mar (sOkam!)  |  BSD-3-Clause  |
#:________________________________________________________________
# nassimp dependencies
import ../types as ai
import ./types  as ex

#_________________________________________________
# Assimp-to-Nim
#_____________________________
# Bool
converter toBool *(some :ai.ReturnCode) :bool=  (some == ai.ReturnCode.success)

#_____________________________
# String
proc toString *(a :var ai.String) :string=
  ## Returns the input ai.String text as a nim.string.
  if a.length == 0: return ""
  result = newString(a.length)
  copymem(result[0].addr, a.data[0].addr, a.length)
#_____________________________
proc `$` *(text :var ai.String) :string=  text.toString
  ## Returns the input ai.String text as a nim.string. Alias for toString

#_____________________________
# Vector types
proc toColor *(c :ai.Color) :ex.Color=  (c.r.float32, c.g.float32, c.b.float32, c.a.float32)
  ## Returns the input ai.Color as a Color that only contains nim types
proc toColorRGB *(c :ai.ColorRGB) :ex.ColorRGB=  (c.r.float32, c.g.float32, c.b.float32)
  ## Returns the input ai.Color as a Color that only contains nim types
proc toVector2 *(v :ptr ai.Vector2) :ex.Vector2=  (v[].x.float32, v[].y.float32)
  ## Returns the input ai.Vector2 as a Vector2 that only contains nim types
proc toVector3 *(v :ai.Vector3) :ex.Vector3=  (v.x.float32, v.y.float32, v.z.float32)
  ## Returns the input ai.Vector3 as a Vector3 that only contains nim types

#_____________________________
# Export data
proc toData *(cam :ptr ai.Camera) :CameraData=
  ## Returns the input ai.Camera as a CameraData object that contains only nim types
  new result
  result.name   = cam.name.toString
  result.pos    = cam.pos.toVector3
  result.up     = cam.up.toVector3
  result.lookat = cam.lookat.toVector3
  result.fovx   = cam.fovx.float32
  result.near   = cam.near.float32
  result.far    = cam.far.float32
  result.ratio  = cam.ratio.float32
  result.width  = cam.width.float32
#_____________________________
proc toData *(light :ptr ai.Light) :LightData=
  ## Returns the input ai.Light as a LighData object that contains only nim types
  new result
  result.kind                 = light.kind
  result.name                 = light.name.toString
  result.position             = light.position.toVector3
  result.direction            = light.direction.toVector3
  result.attenuationConst     = light.attenuationConst.float32
  result.attenuationLinear    = light.attenuationLinear.float32
  result.attenuationQuadratic = light.attenuationQuadratic.float32
  result.colorDiffuse         = light.colorDiffuse.toColorRGB
  result.colorSpecular        = light.colorSpecular.toColorRGB
  result.colorAmbient         = light.colorAmbient.toColorRGB
  result.innerCone            = light.innerCone.float32
  result.outerCone            = light.outerCone.float32

