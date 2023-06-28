#:________________________________________________________________
#  nassimp  |  Copyright (C) Ivan Mar (sOkam!)  |  BSD-3-Clause  |
#:________________________________________________________________
# nassimp dependencies
import ./types

#_____________________________
# Make all functions cdecl
{.push cdecl.}
#_____________________________
# Library Linking
when defined(assimpDynamic): # Link Dynamically
  when defined(windows):
    {.push dynlib: "Assimp(|32|64).dll".}
  elif defined(macosx):
    {.push dynlib: "libassimp.dylib".}
  else:
    {.push dynlib: "libassimp.so".}
else:  # Link statically
  {.push header: "cimport.h".}

#_________________________________________________
# General Purpose
#_____________________________
proc getError *() :cstring {.importc: "aiGetErrorString".}

#_________________________________________________
# Logging
#_____________________________
proc logEnableVerbose *(d :bool) :void {.importc: "aiEnableVerboseLogging".}
proc logGetStream     *(streams :DefaultLogStream; file :cstring) :LogStream {.importc: "aiGetPredefinedLogStream".}
proc logAttach        *(stream :ptr LogStream) :void {.importc: "aiAttachLogStream".}
proc logDetach        *(stream :ptr LogStream) :ReturnCode {.importc: "aiDetachLogStream".}
proc logDetach        *() :void {.importc: "aiDetachAllLogStreams".}

#_________________________________________________
# Process
#_____________________________
proc applyPostProcess *(scene :ptr Scene; flags :ProcessFlags) :ptr Scene {.importc: "aiApplyPostProcessing".}

#_________________________________________________
# Import
#_____________________________
proc release    *(scene :ptr Scene) {.importc: "aiReleaseImport".}
proc importFile *(file :cstring; flags :ProcessFlags) :ptr Scene {.importc: "aiImportFile".}
proc importMem  *(buffer :cstring; length :cuint; flags :ProcessFlags; hint :cstring) :ptr Scene {.importc: "aiImportFileFromMemory".}


#_________________________________________________
# Properties
#_____________________________
proc getTexture *(
    material : ptr Material;
    kind     : TextureType;
    index    : cuint;
    path     : ptr String;
    mapping  : ptr TextureMapping = nil;
    uvIndex  : ptr cuint          = nil;
    blend    : ptr cfloat         = nil;
    op       : ptr TextureOp      = nil;
    mapMode  : ptr TextureMapMode = nil;
    flags    : ptr cuint          = nil;
  ) :ReturnCode {.importc: "aiGetMaterialTexture".}
#_____________________________
proc getMaterialColor *(
    material : ptr Material;
    name     : cstring;
    typ      : cuint;
    index    : cuint;
    color    : ptr ColorRGB;
  ) :ReturnCode {.importc: "aiGetMaterialColor".}
#_____________________________
proc getTextureCount *(
    material : ptr Material;
    kind     : TextureType;
  ) :uint32 {.importc: "aiGetMaterialTextureCount".}
#_____________________________
proc getMaterialFloatArray *(
    material : ptr Material;
    key      : cstring;
    typ      : cuint;
    index    : cuint = 0;
    res      : ptr cfloat;
    max      : ptr cuint = nil;
  ) :ReturnCode {.importc: "aiGetMaterialFloatArray".}

#_____________________________
{.pop.} # << header: "cimport.h"  or   dynlib: "LibName"
{.pop.} # << callconv cdecl

