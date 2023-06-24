# Assimp Materials + Textures
All materials are stored in an array of aiMaterial inside the aiScene.
Each aiMesh refers to one material by its index in the array.
Due to the vastly diverging definitions and usages of material parameters
there is no hard definition of a material structure.
Instead a material is defined by a set of properties accessible by their names.

Textures are organized in stacks, 
each stack being evaluated independently. 

The final color value from a particular texture stack is used in the shading equation. 
For example, the computed color value of the diffuse texture stack (aiTextureType_DIFFUSE) 
  is multipled with the amount of incoming diffuse light
  to obtain the final diffuse color of a pixel.

# UV channels in the context of assimp 
Materials can have more than just one UV texture channel. Like a detail texture on top of your base texture
There are 2d uvs and 3d uvs, assimp has support for both
Example: Accessing the U component will be: texCoords[textureChannelIndex][vertexIndex].x

