#:________________________________________________________________
#  nassimp  |  Copyright (C) Ivan Mar (sOkam!)  |  BSD-3-Clause  |
#:________________________________________________________________
# nassimp dependencies
import ../types as ai
import ./convert

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
proc getMeshID *(node :ptr Node; id :SomeInteger) :int=
  ## Returns the `id` MeshID of the given node.
  if id > node.meshCount-1: raise newException(ImportError, &"Tried to access MeshID {id} of a node that contains only {node.meshCount} meshes.")
  result = node.meshes[id].int

