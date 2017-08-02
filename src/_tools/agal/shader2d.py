from agal import *

__all__ = ["mvp2d", "image"]

def mvp2d(output, vt0, vt1):
	vt1.x = dp4(vt0, WorldMatrix0)
	vt1.y = dp4(vt0, WorldMatrix1)

	vt0.xy = vt1.xy * ScreenMatrix
	vt0.xy += ScreenMatrix.zw

	output @= vt0

def image(output):
	vt0, vt1 = xt(), xt()

	vt0 @= position.xxyy * WMatrix
	vt1 @= normal * MMatrix

	vt1 @= vt1.xxzz + vt1.yyww
	vt1 += vt0
	vt1.yw = vt1 / WMatrix.yyww

	vt0 @= vt1.xzyw * FrameMatrix
	vt0 += UVMatrix

	vt1.zw = vt0
	vt0.zw = position

	mvp2d(output, vt0, vt1)

	return vt1

@input(position="float2", normal="float2")
@const(ScreenMatrix=1, WorldMatrix=2, FrameMatrix=1, UVMatrix=1, WMatrix=1, MMatrix=1)
def vertex(output, uv):
	vt1 = image(output)
	uv @= vt1.zw
	
@input(texture=["2d", "linear", "rgba", "clamp"])
@const(Color=2)
def fragment(output):
	t0 = xt()
	t0 @= tex(uv, texture)
	t0 *= Color0
	output @= t0 + Color1