#:________________________________________________________________
#  nassimp  |  Copyright (C) Ivan Mar (sOkam!)  |  BSD-3-Clause  |
#:________________________________________________________________
# std dependencies
import std/os
# nassimp dependencies
import ../types
import ../procs as ai
# Extension dependencies
import ./types  as ex
import ./scene


#_________________________________________________
# Validate
#_____________________________
template chk (scn :ptr Scene) :void=
  ## Checks that the given scene is valid, or raises an ImportError if its not.
  if scn == nil or scn.isIncomplete() or not scn.hasRoot(): raise newException(ImportError, $ai.getError())

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
  chk result
#_____________________________
proc importMem *(buffer :string; length :SomeInteger; flags = ProcessFlags.default(); hint :cstring= nil) :ptr Scene=
  ## Imports a Scene from the given byte buffer string, using the given set of ProcessFlags
  ## Raises an ImportError if the data couldn't be loaded, is incomplete or has no root node.
  ## Defaults:
  ## - flags: Uses ProcessFlags.default() when omitted
  ## - hint:  Tries to figure out the file format/extension of the buffer data when omitted.
  result = ai.importMem(buffer.cstring, length.cuint, flags, hint)
  chk result


#_________________________________________________
# Smart loading
#_____________________________
proc getScene *(input :string; flags = ProcessFlags.default()) :ptr Scene=
  ## Smart loads the scene contained in the given input string.
  ##   `input` will be treated as a file if it exists.
  ##   If that fails, it will interpret the data as a bytebuffer.
  ## Raises an ImportError if the data couldn't be loaded, is incomplete or has no root node.
  if input.fileExists(): result = input.importFile(flags)
  else:                  result = input.importMem(input.len, flags, hint=nil)
#_____________________________
proc load *(_:typedesc[ModelData];
    input : string;
    flags = ProcessFlags.default();
  ) :ModelData=
  ## Loads a Model from the given input filepath or bytebuffer.
  ##   `input` will be treated as a file if it exists.
  ##   If that fails, it will interpret the data as a bytebuffer.
  ##
  ## ModelData is a sequence of all MeshData contained in the input, ignoring its scene graph.
  ## Ignores everything in the scene that's not MeshData  (eg: lights, cameras, etc)
  ## Use ai.importFile and ai.importMem if you need the raw Assimp's Scene graph.
  ##
  ## Raises an ImportError if the data couldn't be loaded, is incomplete or has no root node.
  let scn = input.getScene(flags)
  # Treat the root node as a single model, and add all its meshes recursively to the result.
  result = scn.getRoot().getModelData(recursive=true)
  # Release the data when done
  ai.release(scn)
#_____________________________
proc load *(_:typedesc[SceneData];
    input : string;
    flags = ProcessFlags.default();
  ) :SceneData=
  ## Loads the scene contained in the given input filepath or bytebuffer.
  ##   `input` will be treated as a file if it exists.
  ##   If that fails, it will interpret the data as a bytebuffer.
  ## Raises an ImportError if the data couldn't be loaded, is incomplete or has no root node.
  let scn  = input.getScene(flags)
  let root = scn.getRoot()
  # Assume that the root node contains every scene model as a child, and make a list of them
  var modelNodes :seq[ptr Node]
  for child in root.ichildren: modelNodes.add child
  # Fill the result with the Data for the models, lights and cameras
  new result
  result.models  = scn.getModelsData(modelNodes)
  result.lights  = scn.getLightsData()
  result.cameras = scn.getCamerasData()
  # Release the data when done
  ai.release(scn)

