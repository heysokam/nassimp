#:________________________________________________________________
#  nassimp  |  Copyright (C) Ivan Mar (sOkam!)  |  BSD-3-Clause  |
#:________________________________________________________________
# nassimp dependencies
import ./types

#_________________________________________________
# Make all functions cdecl and imported from our joint assimp header
{.push callconv: cdecl.}
# TODO:
# {.push header: "cimport.h".}
# {.push header: "scene.h".}
#_____________________________


#_________________________________________________
# General Purpose
#_____________________________
proc getError *() :cstring {.importc: "aiGetErrorString", header: "cimport.h".}

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
proc release    *(scene :ptr Scene) {.importc: "aiReleaseImport", header: "cimport.h".}
proc importFile *(file :cstring; flags :ProcessFlags) :ptr Scene {.importc: "aiImportFile", header: "cimport.h".}
proc importMem  *(buffer :cstring; length :cuint; flags :ProcessFlags; hint :cstring) :ptr Scene {.importc: "aiImportFileFromMemory", header: "cimport.h".}


#_________________________________________________
# Properties
#_____________________________
proc getTexture *(
    material : ptr Material;
    kind     : TextureType;
    index    : cint;
    path     : ptr String;
    mapping  : ptr TextureMapping = nil;
    uvIndex  : ptr cint           = nil;
    blend    : ptr cfloat         = nil;
    op       : ptr TextureOp      = nil;
    mapMode  : ptr TextureMapMode = nil;
    flags    : ptr cint           = nil;
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
{.pop.} # << callconv cdecl
# {.pop.} # << header: "assimp.h"
# {.pop.} # << header: "cimport.h"
# {.pop.} # << header: "scene.h"

