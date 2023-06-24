#:________________________________________________________________
#  nassimp  |  Copyright (C) Ivan Mar (sOkam!)  |  BSD-3-Clause  |
#:________________________________________________________________
# ndk dependencies
import nmath
# nassimp dependencies
import ../types

#_________________________________________________
# Assimp-to-Nim
#_____________________________
# Bool
converter toBool *(some :ReturnCode) :bool=  (some == ReturnCode.success)

#_____________________________
# String
proc `$` *(a :var String) :string=
  result = newString(a.length)
  copymem(addr result[0], addr a.data, a.length)
#_____________________________
proc toString *(text :String) :string=  $text
  ## Returns the input AIString text as a nim.string. Alias for $ from the assimp wrapper

#_____________________________
# Matrix
proc toMat4 *(mat :assimp.Matrix4) :Mat4=
  ## Converts an assimp.Mat4 to a nim.Mat4
  mat4(  mat[00], mat[01], mat[02], mat[03],
         mat[04], mat[05], mat[06], mat[07],
         mat[08], mat[09], mat[10], mat[11],
         mat[12], mat[13], mat[14], mat[15]  )
#_____________________________
proc toMat3 *(mat :assimp.Matrix4) :Mat3=
  ## Converts an assimp.Mat3 to a nim.Mat3
  mat4(  mat[00], mat[01], mat[02],
         mat[03], mat[04], mat[05],
         mat[06], mat[07], mat[08]  )

