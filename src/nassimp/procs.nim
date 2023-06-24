#:________________________________________________________________
#  nassimp  |  Copyright (C) Ivan Mar (sOkam!)  |  BSD-3-Clause  |
#:________________________________________________________________
import ./types

#_________________________________________________
# Make all functions cdecl and imported from our joint assimp header
{.push callconv: cdecl.}
{.push header: currentSourcePath().parentDir()/"assimp.h".}
#_____________________________


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
proc logDetach        *(stream :ptr LogStream) :Return {.importc: "aiDetachLogStream".}
proc logDetach        *() :void {.importc: "aiDetachAllLogStreams".}

#_________________________________________________
# Process
#_____________________________
proc applyPostProcess *(pScene :ptr Scene; pFlags :cuint) :ptr Scene {.importc: "aiApplyPostProcessing".}

#_________________________________________________
# Import
#_____________________________
proc release    *(scene :ScenePtr) {.importc: "aiReleaseImport".}
proc importFile *(filename :cstring; flags :cint) :ScenePtr {.importc: "aiImportFile".}
proc importMem  *(buffer   :cstring; length, flags :uint32; hint :cstring) :ScenePtr {.importc: "aiImportFileFromMemory".}


#_________________________________________________
# Properties
#_____________________________
proc getTexture*(
    material : MaterialPtr;
    kind     : TextureType;
    index    : cint;
    path     : ptr String;
    mapping  : ptr TextureMapping = nil;
    uvIndex  : ptr cint           = nil;
    blend    : ptr cfloat         = nil;
    op       : ptr TextureOp      = nil;
    mapMode  : ptr TextureMapMode = nil;
    flags    : ptr cint           = nil
  ) :ReturnCode {.importc: "aiGetMaterialTexture".}
#_____________________________
proc getMaterialColor *(
    material : MaterialPtr;
    name     : cstring;
    typ      : cuint;
    index    : cuint;
    color    : ptr Color3d
  ) :ReturnCode {.importc: "aiGetMaterialColor".}
#_____________________________
proc getTextureCount *(
    material : MaterialPtr;
    kind     : TextureType
  ) :uint32 {.importc: "aiGetMaterialTextureCount".}
#_____________________________
proc getMaterialFloatArray *(
    material : MaterialPtr;
    key      : cstring;
    typ      : cuint;
    index    : cuint = 0.cuint;
    res      : ptr cfloat;
    max      : ptr cuint = nil
  ) :ReturnCode {.importc: "aiGetMaterialFloatArray".}

#_____________________________
{.pop.} # << callconv cdecl
{.pop.} # << header: "assimp.h"

