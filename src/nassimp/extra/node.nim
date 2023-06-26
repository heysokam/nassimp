#:________________________________________________________________
#  nassimp  |  Copyright (C) Ivan Mar (sOkam!)  |  BSD-3-Clause  |
#:________________________________________________________________
# nassimp dependencies
import ../types as ai
import ./convert


#____________________________________________________
iterator ichildren *(node :ptr Node) :ptr Node=
  ## Yields all children of the given node
  for id in 0..<node.childrenCount: yield node.children[id]
#____________________________________________________
iterator imeshids *(node :ptr Node) :int=
  ## Yields all meshIDs of the given node
  for id in 0..<node.meshCount:  yield node.meshes[id].int

#____________________________________________________
proc getName *(node :ptr Node) :string=  node.name.toString
  ## Returns the name of the node as a Nim string
#_____________________________
proc getTransform *(node :ptr Node) :ai.Matrix4=  node.transformation
  ## Returns the Transform Matrix of the node, converted to vmath.Mat4 matrix
#_____________________________
proc getParent *(node :ptr Node) :ptr Node=  node.parent
  ## Returns the parent node of the given node. Aliast for node.parent
#_____________________________
proc getChild *(node :ptr Node; id :SomeInteger) :ptr Node=
  ## Returns the `id` child of the given node.
  if id > node.childrenCount-1: raise newException(ImportError, &"Tried to access child {id} of a node that contains only {node.childrenCount} children.")
  result = node.children[id]
#_____________________________
proc getMeshID *(node :ptr Node; index :SomeInteger) :int=
  ## Returns the `index`'th MeshID of the given node.
  if index > node.meshCount-1: raise newException(ImportError, &"Tried to access MeshID {index} of a node that contains only {node.meshCount} meshes.")
  result = node.meshes[index].int
#_____________________________
func recMeshIDs (node :ptr Node; list :var seq[int]) :void=
  ## Recursive add all meshIDs of the given node and its children into the input list
  for id in node.imeshids: list.add id
  for child in node.ichildren: child.recMeshIDs(list)
#_____________________________
func getMeshIDs *(node :ptr Node; recursive=false) :seq[int]=
  ## Returns all meshIDs of the given node.
  ## Also adds the ids contained in all its children when recursive=true
  if not recursive:
    for id in node.imeshids: result.add id.int
  elif recursive:
    node.recMeshIDs(result)

