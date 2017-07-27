from agal import *

va(position=FLOAT_2, normal=FLOAT_2)
fs(texture=["2d", "linear", "rgba", "clamp"])
vc(ScreenMatrix=Matrix(1), WorldMatrix=Matrix(2), FrameMatrix=Matrix(1), UVMatrix=Matrix(1), WMatrix=Matrix(1), MMatrix=Matrix(1))
fc(Color=Matrix(2))

def mvp2d(vt0, vt1):
	vt1.x = dp4(vt0, WorldMatrix0)
	vt1.y = dp4(vt0, WorldMatrix1)

	vt0.xy = vt1.xy * ScreenMatrix
	vt0.xy += ScreenMatrix.zw

	op = vt0

def image():
	vt0, vt1 = vt(), vt()

	vt0 @= position.xxyy * WMatrix
	vt1 @= normal * MMatrix

	vt1 @= vt1.xxzz + vt1.yyww
	vt1 += vt0
	vt1.yw = vt1 / WMatrix.yyww

	vt0 @= vt1.xzyw * FrameMatrix
	vt0 += UVMatrix

	vt1.zw = vt0
	vt0.zw = position

	mvp2d(vt0, vt1)

	return vt1


def vertex():
	vt1 = image()
	v0 = vt1.zw
	

def fragment():
	t0 = ft()
	t0 @= tex(v0, texture)
	t0 *= Color0
	oc = t0 + Color1