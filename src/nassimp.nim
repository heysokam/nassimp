#:________________________________________________________________
#  nassimp  |  Copyright (C) Ivan Mar (sOkam!)  |  BSD-3-Clause  |
#:________________________________________________________________


when not defined(assimpDynamic): # Link Statically by default, unless specified
  include ./nassimp/compile

import ./nassimp/types  ; export types
import ./nassimp/procs  ; export procs
import ./nassimp/extras ; export extras

