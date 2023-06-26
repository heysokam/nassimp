## Data Access
All meshes of an imported scene are stored in an array of aiMesh* inside the aiScene.
Nodes refer to them by their index in the array and providing the coordinate system for them, too.

## Material
One mesh uses only a single material everywhere - if parts of the model use a different material,
this part is moved to a separate mesh at the same node.
The mesh refers to its material in the same way as the node refers to its meshes:
  materials are stored in an array inside aiScene,
  the mesh stores only an index into this array.

## Data
An aiMesh is defined by a series of data channels.
The presence of these data channels is defined by the contents of the imported file:
  by default there are only those data channels present in the mesh that were also found in the file.
The only channels guaranteed to be always present are aiMesh::mVertices and aiMesh::mFaces.
You can test for the presence of other data by testing the pointers against NULL or use the helper functions provided by aiMesh.
You may also specify several post processing flags at Importer::ReadFile() to let assimp calculate or recalculate additional data channels.

A single aiMesh may contain a set of triangles and polygons.
A single vertex does always have a position.
In addition it may have:
- one normal,
- one tangent and bitangent,
- zero to AI_MAX_NUMBER_OF_TEXTURECOORDS (4 at the moment) texture coords
- zero to AI_MAX_NUMBER_OF_COLOR_SETS (4) vertex colors.
- May or may not have a set of bones described by an array of aiBone structures.

