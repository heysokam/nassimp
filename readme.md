![nassimp](./doc/res/gh_banner.png)
# Assimp for Nim
The [Open Asset Import Library](https://github.com/assimp/assimp/) is a library to load various 3d file formats into a shared, in-memory format.  
It supports more than 40 file formats for import and a growing selection of file formats for export  

This wrapper is:  
- Extended:           New Nim types and functions to access the imported data  
- Statically Linked:  Its functionality gets included into your binary. No need to distribute `.dll`, `.dylib` files.  
- Simple:             Focused on file importing and data reading.
- Ergonomic:          Extra Nim code, to avoid having to manage raw C arrays and pointers in your app.

Note:  
Dynamic linking might be implemented in the future.  
In the meantime, use [beef's wrapper](https://github.com/beef331/nimassimp), which is dynamically linked.  

**Requirements**:
```md
cmake  : To build Assimp
nim    : To use the library
```

## How to
```nim
# Smart load from a string  ( Nim extension )
import nassimp as ai
let input = "......"               # Can contain a bytebuffer or a filepath
let scene = input.load(SceneData)  # Treats the input as a Scene, with Models, Lights, Cameras, etc
let model = input.load(ModelData)  # Treats the input as a single Model
```

```nim
# Raw access to the ai.Scene object:  
import nassimp as ai

let scene   = ai.importFile("path/to/model.gltf")  # Import the scene from a file path
# let scene = ai.importMem( byteBuffer )           # Import the scene from a string buffer
echo scene.meshCount                               # ... Do something with the imported data
ai.release(scene)                                  # Release the data when done

# Useful for implementations that require the raw Assimp's Scene Graph.  
```

