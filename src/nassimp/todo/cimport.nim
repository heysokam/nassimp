const
  AI_SCENE_FLAGS_INCOMPLETE* = 0x1
  AI_SCENE_FLAGS_VALIDATED* = 0x2
  AI_SCENE_FLAGS_VALIDATION_WARNING* = 0x4
  AI_SCENE_FLAGS_NON_VERBOSE_FORMAT* = 0x8
  AI_SCENE_FLAGS_TERRAIN* = 0x10
  AI_SCENE_FLAGS_ALLOW_SHARED* = 0x20

type PropertyStore *{.bycopy.} = object
  sentinel *:char


proc importEx  *(pFile :cstring; pFlags :cuint; pFS :ptr FileIO) :ptr Scene {.importc: "aiImportFileEx".}
proc importEx  *(pFile :cstring; pFlags :cuint; pFS :ptr FileIO; pProps :ptr PropertyStore) :ptr Scene {.importc: "aiImportFileExWithProperties".}
proc importMem *(pBuffer :cstring; pLength :cuint; pFlags :cuint; pHint :cstring; pProps :ptr PropertyStore) :ptr Scene {.importc: "aiImportFileFromMemoryWithProperties".}

proc isExtensionSupported  *(szExtension :cstring) :bool {.importc: "aiIsExtensionSupported".}
proc getExtensionList      *(szOut :ptr String) :void {.importc: "aiGetExtensionList".}
proc getMemoryRequirements *(pIn :ptr Scene; info :ptr MemoryInfo) :void {.importc: "aiGetMemoryRequirements".}
proc createPropertyStore   *() :ptr PropertyStore :void {.importc: "aiCreatePropertyStore".}
proc release               *(p :ptr PropertyStore) :void {.importc: "aiReleasePropertyStore".}
proc setImportProperty     *(store :ptr PropertyStore; szName :cstring; value :cint) :void {.importc: "aiSetImportPropertyInteger".}
proc setImportProperty     *(store :ptr PropertyStore; szName :cstring; value :cfloat) :void {.importc: "aiSetImportPropertyFloat".}
proc setImportProperty     *(store :ptr PropertyStore; szName :cstring; st :ptr String) :void {.importc: "aiSetImportPropertyString".}
proc setImportProperty     *(store :ptr PropertyStore; szName :cstring; mat :ptr Matrix4) :void {.importc: "aiSetImportPropertyMatrix".}
proc getImportFormatCount  *() :csize_t {.importc: "aiGetImportFormatCount".}
proc getImportFormatDesc   *(pIndex :csize_t) :ptr ImporterDesc {.importc: "aiGetImportFormatDescription".}

