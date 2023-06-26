#:________________________________________________________________
#  nassimp  |  Copyright (C) Ivan Mar (sOkam!)  |  BSD-3-Clause  |
#:________________________________________________________________
# nassimp dependencies
import ../types as ai
import ./types  as ex


#_____________________________
proc getSize *(tex :ptr Texture) :UVector2=
  ## Returns the size of the texture as a UVector2
  result.x = tex.width
  result.y = tex.height
#_____________________________
proc getHint *(tex :ptr Texture) :string=
  ## Returns the format hint of the texture as a nim.string
  result = newString( tex.achFormatHint.len-1 )
  for ch in tex.achFormatHint:
    if ch == '\0': continue
    result.add ch.char
#_____________________________
proc getPixels *(tex :ptr Texture) :seq[ai.Texel]=
  ## Returns the pixel data of the given texture as a seq[ai.Texel]
  let pixelCount =
    if tex.height == 0: tex.width  # Texture is considered compressed by Assimp
    else:               tex.width*tex.height
  for pix in 0..<pixelCount:
    result.add tex.pcData[pix]
#_____________________________
proc getData *(tex :ptr Texture) :TextureData=
  ## Returns the texture data for the given input texture
  new result
  result.size   = tex.getSize()
  result.format = tex.getHint()
  result.pixels = tex.getPixels()

