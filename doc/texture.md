# Textures
Normally textures used by assets are stored in separate files,
however, there are file formats embedding their textures directly into the model file.
Such textures are loaded into an aiTexture structure.

There are two cases:
## 1) The texture is NOT compressed
Its color data is directly stored in the aiTexture structure as an array of aiTexture::mWidth * aiTexture::mHeight aiTexel structures.

Each aiTexel represents a pixel (or "texel") of the texture image.
The color data is stored in an unsigned RGBA8888 format,
which can be easily used for both Direct3D and OpenGL (swizzling the order of the color components might be necessary).

RGBA8888 has been chosen because it is well-known, easy to use and natively supported by nearly all graphics APIs.

## 2) The texture IS compressed
This applies if aiTexture::mHeight == 0 is fullfilled.
Then, texture is stored in a "compressed" format such as DDS or PNG.

The term "compressed" does not mean that the texture data must actually be compressed,
however the texture was found in the model file as if it was stored in a separate file on the harddisk.

Appropriate decoders (such as libjpeg, libpng, D3DX, DevIL) are required to load theses textures.
- aiTexture::mWidth specifies the size of the texture data in bytes,
- aiTexture::pcData is a pointer to the raw image data
- aiTexture::achFormatHint is either zeroed or contains the most common file extension of the embedded texture's format.
  This value is only set if assimp is able to determine the file format.

