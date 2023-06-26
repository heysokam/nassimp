# Animations
An imported scene may contain zero to x aiAnimation entries.
An animation in this context is a set of keyframe sequences where each sequence describes the orientation of a single node in the hierarchy over a limited time span.
Animations of this kind are usually used to animate the skeleton of a skinned mesh, but there are other uses as well.

An aiAnimation has a duration.
The duration as well as all time stamps are given in ticks.
To get the correct timing, all time stamp thus have to be divided by aiAnimation::mTicksPerSecond.
Beware, though, that certain combinations of file format and exporter don't always store this information in the exported file.
In this case, mTicksPerSecond is set to 0 to indicate the lack of knowledge.

The aiAnimation consists of a series of aiNodeAnim's.
Each bone animation affects a single node in the node hierarchy only, the name specifying which node is affected.
For this node the structure stores three separate key sequences:
- a vector key sequence for the position,
- a quaternion key sequence for the rotation
- another vector key sequence for the scaling.
All 3d data is local to the coordinate space of the node's parent,
that means in the same space as the node's transformation matrix.
There might be cases where animation tracks refer to a non-existent node by their name,
but this should not be the case in your every-day data.

To apply such an animation you need to identify the animation tracks that refer to actual bones in your mesh.
Then for every track:
a) Find the keys that lay right before the current anim time.
b) Optional: interpolate between these and the following keys.
c) Combine the calculated position, rotation and scaling to a tranformation matrix
d) Set the affected node's transformation to the calculated matrix.
If you need hints on how to convert to or from quaternions, have a look at the Matrix&Quaternion FAQ. I suggest using logarithmic interpolation for the scaling keys if you happen to need them - usually you don't need them at all.

