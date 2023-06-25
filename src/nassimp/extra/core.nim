#:________________________________________________________________
#  nassimp  |  Copyright (C) Ivan Mar (sOkam!)  |  BSD-3-Clause  |
#:________________________________________________________________
# nassimp dependencies
import ../types
import ../procs as ai
# Extras dependencies
import ./scene


#_________________________________________________
# Import
#_____________________________
proc importFile *(file :string; flags = ProcessFlags.default()) :ptr Scene=
  ## Imports the given file path, using the given set of ProcessFlags
  ## Raises an ImportError if the file couldn't be loaded, is incomplete or has no root node.
  ## Defaults:
  ## - file:  Path is read literally as it is given.
  ## - flags: Uses ProcessFlags.default() when omitted
  result = ai.importFile(file.cstring, flags)
  if result == nil or result.isIncomplete() or not result.hasRoot(): raise newException(ImportError, $ai.getError())

