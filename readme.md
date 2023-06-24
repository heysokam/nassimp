![nassimp](./doc/res/gh_banner.png)
# Static Assimp for Nim
The [Open Asset Import Library](https://github.com/assimp/assimp/) is a library to load various 3d file formats into a shared, in-memory format.  
It supports more than 40 file formats for import and a growing selection of file formats for export

This wrapper is Statically Linked:  
Its functionality gets included into your binary.  
Removes the need to distribute your own copy of `Assimp64.dll` / `libassimp.dylib`, etc.  
Use [beef's wrapper](https://github.com/beef331/nimassimp) if you prefer dynamic linking.

