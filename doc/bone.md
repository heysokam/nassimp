# Bones
A mesh may have a set of bones in the form of aiBone structures.  
Bones are a means to deform a mesh according to the movement of a skeleton.  
Each bone has a name and a set of vertices on which it has influence.
Its offset matrix declares the transformation needed to transform from mesh space to the local space of this bone.

Using the bones name you can find the corresponding node in the node hierarchy.
This node in relation to the other bones' nodes defines the skeleton of the mesh.
Unfortunately there might also be nodes which are not used by a bone in the mesh,
but still affect the pose of the skeleton because they have child nodes which are bones.
So when creating the skeleton hierarchy for a mesh I suggest the following method:

a) Create a map or a similar container to store which nodes are necessary for the skeleton. Pre-initialise it for all nodes with a "no".
b) For each bone in the mesh:
b1) Find the corresponding node in the scene's hierarchy by comparing their names.
b2) Mark this node as "yes" in the necessityMap.
b3) Mark all of its parents the same way until you 1) find the mesh's node or 2) the parent of the mesh's node.
c) Recursively iterate over the node hierarchy
c1) If the node is marked as necessary, copy it into the skeleton and check its children
c2) If the node is marked as not necessary, skip it and do not iterate over its children.
Reasons: you need all the parent nodes to keep the transformation chain intact.
For most file formats and modelling packages: 
  the node hierarchy of the skeleton is either a child of the mesh node
  or a sibling of the mesh node but this is by no means a requirement so you shouldn't rely on it.
The node closest to the root node is your skeleton root, from there you start copying the hierarchy.
You can skip every branch without a node being a bone in the mesh.
  _That's why the algorithm skips the whole branch if the node is marked as "not necessary"_.

You should now have a mesh in your engine with a skeleton that is a subset of the imported hierarchy.

