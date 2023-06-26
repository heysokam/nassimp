#:________________________________________________________________
#  nassimp  |  Copyright (C) Ivan Mar (sOkam!)  |  BSD-3-Clause  |
#:________________________________________________________________
# std dependencies
import std/os
# nassimp dependencies
import ../types


#_________________________________________________
# Probably will never use. We have vmath :shrug:  |
#_________________________________________________|
{.push cdecl.}
{.push header: "cimport.h".}
#_________________________________________________
# Vector2
#_____________________________
proc equal         *(a :ptr Vector2; b :ptr Vector2) :bool {.importc: "aiVector2AreEqual".}
proc equalEpsilon  *(a :ptr Vector2; b :ptr Vector2; epsilon :cfloat) :bool {.importc: "aiVector2AreEqualEpsilon".}
proc add           *(dst :ptr Vector2; src :ptr Vector2) :void {.importc: "aiVector2Add".}
proc subtract      *(dst :ptr Vector2; src :ptr Vector2) :void {.importc: "aiVector2Subtract".}
proc scale         *(dst :ptr Vector2; s :cfloat) :void {.importc: "aiVector2Scale".}
proc symMul        *(dst :ptr Vector2; other :ptr Vector2) :void {.importc: "aiVector2SymMul".}
proc divide        *(dst :ptr Vector2; s :cfloat) :void {.importc: "aiVector2DivideByScalar".}
proc divide        *(dst :ptr Vector2; v :ptr Vector2) :void {.importc: "aiVector2DivideByVector".}
proc length        *(v :ptr Vector2) :cfloat {.importc: "aiVector2Length".}
proc lengthSquared *(v :ptr Vector2) :cfloat {.importc: "aiVector2SquareLength".}
proc negate        *(dst :ptr Vector2) :void {.importc: "aiVector2Negate".}
proc dot           *(a :ptr Vector2; b :ptr Vector2) :cfloat {.importc: "aiVector2DotProduct".}
proc normalize     *(v :ptr Vector2) :void {.importc: "aiVector2Normalize".}
#_____________________________
# Vector3
proc equal         *(a :ptr Vector3; b :ptr Vector3) :bool {.importc: "aiVector3AreEqual".}
proc equalEpsilon  *(a :ptr Vector3; b :ptr Vector3; epsilon :cfloat) :bool {.importc: "aiVector3AreEqualEpsilon".}
proc lessThan      *(a :ptr Vector3; b :ptr Vector3) :bool {.importc: "aiVector3LessThan".}
proc add           *(dst :ptr Vector3; src :ptr Vector3) :void {.importc: "aiVector3Add".}
proc subtract      *(dst :ptr Vector3; src :ptr Vector3) :void {.importc: "aiVector3Subtract".}
proc scale         *(dst :ptr Vector3; s :cfloat) :void {.importc: "aiVector3Scale".}
proc symMul        *(dst :ptr Vector3; other :ptr Vector3) :void {.importc: "aiVector3SymMul".}
proc divide        *(dst :ptr Vector3; s :cfloat) :void {.importc: "Vector3ivideByScalar".}
proc divide        *(dst :ptr Vector3; v :ptr Vector3) :void {.importc: "Vector3ivideByVector".}
proc length        *(v :ptr Vector3) :cfloat {.importc: "aiVector3Length".}
proc lengthSquared *(v :ptr Vector3) :cfloat {.importc: "aiVector3SquareLength".}
proc negate        *(dst :ptr Vector3) :void {.importc: "aiVector3Negate".}
proc dot           *(a :ptr Vector3; b :ptr Vector3) :cfloat {.importc: "Vector3otProduct"}
proc cross         *(dst :ptr Vector3; a :ptr Vector3; b :ptr Vector3) :void {.importc: "aiVector3CrossProduct".}
proc normalize     *(v :ptr Vector3) :void {.importc: "aiVector3Normalize".}
proc normalizeSafe *(v :ptr Vector3) :void {.importc: "aiVector3NormalizeSafe".}
proc rotate        *(v :ptr Vector3; q :ptr Quat) :void {.importc: "aiVector3RotateByQuaternion".}
proc transformBy   *(v :ptr Vector3; m :ptr Matrix3) :void {.importc: "aiTransformVecByMatrix3".}
proc transformBy   *(v :ptr Vector3; m :ptr Matrix4) :void {.importc: "aiTransformVecByMatrix4".}
#_____________________________
# Matrix3
proc identity         *(mat :ptr Matrix3) :void {.importc: "aiIdentityMatrix3".}
proc fromMatrix4      *(dst :ptr Matrix3; mat :ptr Matrix4) :void {.importc: "aiMatrix3FromMatrix4".}
proc fromQuat         *(mat :ptr Matrix3; q :ptr Quat) :void {.importc: "aiMatrix3FromQuaternion".}
proc fromRotationAxis *(mat :ptr Matrix3; axis :ptr Vector3; angle :cfloat) :void {.importc: "aiMatrix3FromRotationAroundAxis".}
proc multiply         *(dst :ptr Matrix3; src :ptr Matrix3) :void {.importc: "aiMultiplyMatrix3".}
proc equal            *(a :ptr Matrix3; b :ptr Matrix3) :bool {.importc: "aiMatrix3AreEqual".}
proc equalEpsilon     *(a :ptr Matrix3; b :ptr Matrix3; epsilon :cfloat) :bool {.importc: "aiMatrix3AreEqualEpsilon".}
proc inverse          *(mat :ptr Matrix3) :void {.importc: "aiMatrix3Inverse".}
proc determinant      *(mat :ptr Matrix3) :cfloat {.importc: "aiMatrix3Determinant".}
proc rotationZ        *(mat :ptr Matrix3; angle :cfloat) :void {.importc: "aiMatrix3RotationZ".}
proc transpose        *(mat :ptr Matrix3) :void {.importc: "aiTransposeMatrix3".}
proc translation      *(mat :ptr Matrix3; translation :ptr Vector2) :void {.importc: "aiMatrix3Translation".}
proc fromTo           *(mat :ptr Matrix3; `from` :ptr Vector3; to :ptr Vector3) :void {.importc: "aiMatrix3FromTo".}
#_____________________________
# Matrix4
proc identity           *(mat :ptr Matrix4) :void {.importc: "aiIdentityMatrix4".}
proc fromMatrix3        *(dst :ptr Matrix4; mat :ptr Matrix3) :void {.importc: "aiMatrix4FromMatrix3".}
proc fromScalingQuatPos *(mat :ptr Matrix4; scaling :ptr Vector3; rotation :ptr Quaternion; position :ptr Vector3) :void {.importc: "aiMatrix4FromScalingQuaternionPosition".}
proc fromRotationAxis   *(mat :ptr Matrix4; axis :ptr Vector3; angle :cfloat) :void {.importc: "aiMatrix4FromRotationAroundAxis".}
proc multiply           *(dst :ptr Matrix4; src :ptr Matrix4) :void {.importc: "aiMultiplyMatrix4".}
proc add                *(dst :ptr Matrix4; src :ptr Matrix4) :void {.importc: "aiMatrix4Add".}
proc equal              *(a :ptr Matrix4; b :ptr Matrix4) :bool {.importc: "aiMatrix4AreEqual".}
proc equalEpsilon       *(a :ptr Matrix4; b :ptr Matrix4; epsilon :cfloat) :bool {.importc: "aiMatrix4AreEqualEpsilon".}
proc inverse            *(mat :ptr Matrix4) :void {.importc: "aiMatrix4Inverse".}
proc determinant        *(mat :ptr Matrix4) :cfloat {.importc: "aiMatrix4Determinant".}
proc isIdentity         *(mat :ptr Matrix4) :bool {.importc: "aiMatrix4IsIdentity".}
proc decompose          *(mat :ptr Matrix4; scaling :ptr Vector3; rotation :ptr Quat; position :ptr Vector3) :void {.importc: "aiDecomposeMatrix".}
proc decomposeEulerPos  *(mat :ptr Matrix4; scaling :ptr Vector3; rotation :ptr Vector3; position :ptr Vector3) :void {.importc: "aiMatrix4DecomposeIntoScalingEulerAnglesPosition".}
proc decomposeAxisPos   *(mat :ptr Matrix4; scaling :ptr Vector3; axis :ptr Vector3; angle :ptr ai_real; position :ptr Vector3) :void {.importc: "aiMatrix4DecomposeIntoScalingAxisAnglePosition".}
proc decomposeNoScaling *(mat :ptr Matrix4; rotation :ptr Quat; position :ptr Vector3) :void {.importc: "aiMatrix4DecomposeNoScaling".}
proc fromEulerAngles    *(mat :ptr Matrix4; x :cfloat; y :cfloat; z :cfloat) :void {.importc: "aiMatrix4FromEulerAngles".}
proc rotationX          *(mat :ptr Matrix4; angle :cfloat) :void {.importc: "aiMatrix4RotationX".}
proc rotationY          *(mat :ptr Matrix4; angle :cfloat) :void {.importc: "aiMatrix4RotationY".}
proc rotationZ          *(mat :ptr Matrix4; angle :cfloat) :void {.importc: "aiMatrix4RotationZ".}
proc transpose          *(mat :ptr Matrix4) :void {.importc: "aiTransposeMatrix4".}
proc translation        *(mat :ptr Matrix4; translation :ptr Vector3) :void {.importc: "aiMatrix4Translation".}
proc scaling            *(mat :ptr Matrix4; scaling :ptr Vector3) :void {.importc: "aiMatrix4Scaling".}
proc fromTo             *(mat :ptr Matrix4; `from` :ptr Vector3; to :ptr Vector3) :void {.importc: "aiMatrix4FromTo".}
#_____________________________
# Quaternions
proc fromMatrix         *(q :ptr Quat; mat :ptr Matrix3) :void {.importc: "aiCreateQuaternionFromMatrix".}
proc fromEulerAngles    *(q :ptr Quat; x :cfloat; y :cfloat; z :cfloat) :void {.importc: "aiQuaternionFromEulerAngles".}
proc fromAxisAngle      *(q :ptr Quat; axis :ptr Vector3; angle :cfloat) :void {.importc: "aiQuaternionFromAxisAngle".}
proc fromNormalizedQuat *(q :ptr Quat; normalized :ptr Vector3) :void {.importc: "aiQuaternionFromNormalizedQuaternion".}
proc equal              *(a :ptr Quat; b :ptr Quat) :bool {.importc: "aiQuaternionAreEqual".}
proc equalEpsilon       *(a :ptr Quat; b :ptr Quat;a epsilon :cfloat) :bool {.importc: "aiQuaternionAreEqualEpsilon".}
proc normalize          *(q :ptr Quat) :void {.importc: "aiQuaternionNormalize".}
proc conjugate          *(q :ptr Quat) :void {.importc: "aiQuaternionConjugate".}
proc multiply           *(dst :ptr Quat; q :ptr Quat) :void {.importc: "aiQuaternionMultiply".}
proc interpolate        *(dst :ptr Quat; start :ptr Quat; `end` :ptr Quat; factor :cfloat) :void {.importc: "aiQuaternionInterpolate".}


#_____________________________
{.pop.} # << callconv cdecl
{.pop.} # << header: "assimp.h"

