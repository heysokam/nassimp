#:________________________________________________________________
#  nassimp  |  Copyright (C) Ivan Mar (sOkam!)  |  BSD-3-Clause  |
#:________________________________________________________________
# External dependencies
import pkg/chroma
# ndk dependencies
import nmath
# nassimp dependencies
import ../types

#_____________________________
# Property Access
func matId *(m :ptr Mesh) :int=  m.materialIndex.int
  ## Alias for Mesh.materialIndex.int

#_____________________________
# Property Checks
proc hasPositions *(mesh :ptr Mesh) :bool {.inline.}=  (mesh.vertexCount > 0 and not mesh.vertices.isNil)
proc hasFaces     *(mesh :ptr Mesh) :bool {.inline.}=  (mesh.faceCount > 0 and not mesh.faces.isNil)
proc hasNormals   *(mesh :ptr Mesh) :bool {.inline.}=  (mesh.vertexCount > 0 and not mesh.normals.isNil)
proc hasUvs       *(mesh :ptr Mesh) :bool {.inline.}=  mesh.numUVcomponents[0] > 0
proc hasColors    *(mesh :ptr Mesh) :bool {.inline.}=  mesh.colors[0] != nil


#_____________________________
iterator ifaces *(mesh :ptr Mesh) :Face=
  ## Yields all faces of the given mesh
  for x in 0..<mesh.faceCount: yield mesh.faces[x]
#_____________________________
iterator iindices*(face :Face) :cint=
  ## Yields all indices of the given face
  for x in 0..<face.indexCount: yield face.indices[x]
#_____________________________
iterator ivertices *(m :ptr Mesh) :Vec3=
  let vertices = cast[ptr UncheckedArray[Vector3]](m.vertices)
  for vert in 0..<m.vertexCount:
    yield vec3(vertices[vert].x.float32, vertices[vert].y.float32, vertices[vert].z.float32)
#________________________________________
iterator inormals *(m :ptr Mesh) :Vec3=
  let normals = cast[ptr UncheckedArray[Vector3]](m.normals)
  for vert in 0..<m.vertexCount:
    yield vec3(normals[vert].x.float32, normals[vert].y.float32, normals[vert].z.float32)
#________________________________________
iterator iuvs *(m :ptr Mesh) :Vec2=
  let channel = 0  # TODO: Support for more channels if they exist
  let verts   = cast[ptr UncheckedArray[Vector3]](m.texCoords[channel])
  for vert in 0..<m.vertexCount:
    yield vec2(verts[vert].x.float32, verts[vert].y.float32)
#________________________________________
iterator icolors *(m :ptr Mesh) :chroma.Color=
  let colors = m.colors
  for vert in 0..<m.vertexCount:
    yield chroma.color(colors[vert].r.float32, colors[vert].g.float32, colors[vert].b.float32, colors[vert].a.float32)

