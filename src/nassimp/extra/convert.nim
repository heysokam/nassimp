#:________________________________________________________________
#  nassimp  |  Copyright (C) Ivan Mar (sOkam!)  |  BSD-3-Clause  |
#:________________________________________________________________
# nassimp dependencies
import ../types as ai

#_________________________________________________
# Assimp-to-Nim
#_____________________________
# Bool
converter toBool *(some :ai.ReturnCode) :bool=  (some == ai.ReturnCode.success)

#_____________________________
# String
#_____________________________
proc toString *(a :var ai.String) :string=
  ## Returns the input ai.String text as a nim.string.
  result = newString(a.length)
  copymem(result[0].addr, a.data[0].addr, a.length)
proc `$` *(text :var ai.String) :string=  text.toString
  ## Returns the input ai.String text as a nim.string. Alias for toString

