#:________________________________________________________________
#  nassimp  |  Copyright (C) Ivan Mar (sOkam!)  |  BSD-3-Clause  |
#:________________________________________________________________
# std dependencies
import std/strformat
# nassimp dependencies
import ../types as ai
import ./types  as ex
import ./convert


#_________________________________________________
# Property Checks
#_____________________________
proc hasIndices    *(m :ptr Mesh) :bool {.inline.}=  m.faceCount     > 0 and not m.faces.isNil
proc hasPositions  *(m :ptr Mesh) :bool {.inline.}=  m.vertexCount   > 0 and not m.vertices.isNil
proc hasColors     *(m :ptr Mesh) :bool {.inline.}=  m.vertexCount   > 0 and not m.colors[0].isNil
proc hasUVs        *(m :ptr Mesh) :bool {.inline.}=  m.vertexCount   > 0 and m.numUVcomponents[0] > 0
proc hasNormals    *(m :ptr Mesh) :bool {.inline.}=  m.vertexCount   > 0 and not m.normals.isNil
proc hasTangents   *(m :ptr Mesh) :bool {.inline.}=  m.vertexCount   > 0 and not m.tangents.isNil
proc hasBitangents *(m :ptr Mesh) :bool {.inline.}=  m.vertexCount   > 0 and not m.bitangents.isNil
proc hasBones      *(m :ptr Mesh) :bool {.inline.}=  m.boneCount     > 0 and not m.bones.isNil
proc hasAnimMeshes *(m :ptr Mesh) :bool {.inline.}=  m.animMeshCount > 0 and not m.animMeshes.isNil
proc hasMaterial   *(m :ptr Mesh) :bool {.inline.}=  m.materialIndex.int > 0


#_________________________________________________
# Field Iterators
#_____________________________
iterator ifaces *(mesh :ptr Mesh) :Face=
  ## Yields all faces of the given mesh
  for x in 0..<mesh.faceCount: yield mesh.faces[x]
#_____________________________
iterator iindices*(face :Face) :uint32=
  ## Yields all indices of the given face
  for x in 0..<face.indexCount: yield face.indices[x].uint32
#_____________________________
iterator ivertices *(m :ptr Mesh) :ai.Vector3=
  ## Yields all vertex positions of the given mesh
  for vert in 0..<m.vertexCount: yield m.vertices[vert]
#________________________________________
iterator inormals *(m :ptr Mesh) :ai.Vector3=
  ## Yields all vertex normals of the given mesh
  for vert in 0..<m.vertexCount: yield m.normals[vert]
#________________________________________
iterator iuvs *(m :ptr Mesh) :ai.Vector2=
  ## Yields all texture coordinates of the given mesh
  for vert in 0..<m.vertexCount: yield m.texCoords[vert][]
#________________________________________
iterator icolors *(m :ptr Mesh) :ptr ai.Color=
  ## Yields all vertex colors of the given mesh
  for vert in 0..<m.vertexCount: yield m.colors[vert]
#________________________________________
iterator itangents *(m :ptr Mesh) :ai.Vector3=
  ## Yields all vertex tangents of the given mesh
  for vert in 0..<m.vertexCount: yield m.tangents[vert]
#________________________________________
iterator ibitangents *(m :ptr Mesh) :ai.Vector3=
  ## Yields all vertex bitangents of the given mesh
  for vert in 0..<m.vertexCount: yield m.bitangents[vert]
#________________________________________
iterator ibones *(m :ptr Mesh) :ptr Bone=
  ## Yields all bones of the given mesh
  for bone in 0..<m.boneCount: yield m.bones[bone]
#________________________________________
iterator ianimMeshes *(m :ptr Mesh) :ptr AnimMesh=
  ## Yields all animation meshes of the given Mesh
  for mesh in 0..<m.animMeshCount: yield m.animMeshes[mesh]


#_________________________________________________
# Property Access
#_____________________________
# General properties
func getTypes *(m :ptr Mesh) :PrimitiveTypes=  m.primitiveTypes
  ## Returns the type of primitives contained in the given mesh
  ## Alias for Mesh.primitiveTypes
func getMatID *(m :ptr Mesh) :int=  m.materialIndex.int
  ## Alias for Mesh.materialIndex.int
func getName  *(m :ptr Mesh) :string=  m.name.toString
  ## Returns the name of the mesh as a nim.string
#_____________________________
# Vertex properties
func getIndices *(m :ptr Mesh) :seq[UVector3]=
  ## Returns a seq with all the indices of the given mesh.
  ## Will raise an ImportError if the mesh faces are not triangulated.
  ## TODO: non-triangulated support  (height-maps)
  result = newSeqOfCap[UVector3](m.faceCount)
  for face in m.ifaces:
    if face.indexCount != 3: raise newException(ImportError, &"The mesh {m.getName()} contains non-triangulated faces.")
    let curr = result.len
    result.setLen(curr + face.indexCount.int)  # increase the size of the seq
    copyMem( result[curr].addr, face.indices[0].addr, face.indexCount.int * cuint.sizeof )
func getPositions *(m :ptr Mesh) :seq[ex.Vector3]=
  ## Returns a seq with all the vertex positions of the given Mesh
  for pos in m.ivertices:  result.add pos.toVector3
func getColors *(m :ptr Mesh) :seq[ex.Color]=
  ## Returns a seq with all the vertex colors of the given Mesh
  for color in m.icolors:  result.add color[].toColor  # Dereference the iterator Color ptr, so we get a copy
func getUVs *(m :ptr Mesh; id :SomeInteger= 0) :seq[ex.Vector2]=
  ## Returns a seq with all the vertex UVs of the given Mesh at UV position id
  for uv in m.iuvs():  result.add uv.toVector2
func getNormals *(m :ptr Mesh) :seq[ex.Vector3]=
  ## Returns a seq with all the vertex normals of the given Mesh
  for norm in m.inormals:  result.add norm.toVector3
func getTangents *(m :ptr Mesh) :seq[ex.Vector3]=
  ## Returns a seq with all the vertex tangents of the given Mesh
  for tan in m.itangents:  result.add tan.toVector3
func getBitangents *(m :ptr Mesh) :seq[ex.Vector3]=
  ## Returns a seq with all the vertex bitangents of the given Mesh
  for bitan in m.ibitangents:  result.add bitan .toVector3
func getBones *(m :ptr Mesh) :seq[Bone]=
  ## Returns a seq with all bones of the given Mesh
  for bone in m.ibones:  result.add bone[]  # Dereference the iterator Bone ptr, so we get a copy
func getAnimMeshes *(m :ptr Mesh) :seq[ptr AnimMesh]=
  ## Returns a seq with all animation meshes of the given Mesh
  # for mesh in m.ianimMeshes:  result.add mesh[]  # Dereference the iterator AnimMesh ptr, so we get a copy
  for id in 0..<m.animMeshCount: result.add m.animMeshes[id] # Dereference the AnimMesh ptr, so we get a copy

#_________________________________________________
# Full data Access
#_____________________________
func getData *(m :ptr Mesh) :MeshData=
  ## Returns a MeshData object, that contains sequences with all data of the given mesh.
  ## WRN: The material information must be queried from the Scene, with the material.id, after calling this proc.
  new result
  result.name       = m.getName()
  result.material   = MaterialData(id: m.getMatID())
  result.primitives = m.getTypes()
  if m.hasIndices:    result.inds       = m.getIndices()
  if m.hasPositions:  result.pos        = m.getPositions()
  if m.hasColors:     result.colors     = m.getColors()
  if m.hasUVs:        result.uvs        = m.getUVs()
  if m.hasNormals:    result.norms      = m.getNormals()
  if m.hasTangents:   result.tans       = m.getTangents()
  if m.hasBitangents: result.bitans     = m.getBitangents()
  # if m.hasBones:      result.bones      = m.getBones()
  # if m.hasAnimMeshes: result.animMeshes = m.getAnimMeshes()

