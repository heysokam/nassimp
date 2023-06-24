#:________________________________________________________________
#  nassimp  |  Copyright (C) Ivan Mar (sOkam!)  |  BSD-3-Clause  |
#:________________________________________________________________
# nassimp dependencies
import ../types
import ../procs

#_________________________________________________
# Import
#_____________________________
proc importFile *(file :string; flags :set[ImportProcess]) :ptr Scene=
  let newFlags = block:
    var res: cint
    for x in flags: res = res or ProcessLut[x]
    res
  importFile(filename.cstring, newFlags)

