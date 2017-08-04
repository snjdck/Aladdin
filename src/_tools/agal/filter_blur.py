from agal import *

from shader2d import *

@input(position="float2", normal="float2")
@const(ScreenMatrix=1, WorldMatrix=2, FrameMatrix=1, UVMatrix=1, WMatrix=1, MMatrix=1, Offset=1)
def vertex(output, uv, v1, v2):
	vt1 = image(output)
	uv @= vt1.zw
	v1 @= vt1.zwzw - Offset.zwxy
	v2 @= vt1.zwzw + Offset

@input(texture=["2d", "linear", "clamp"])
@const(weight=1)
def fragment(oc):
	ft = xt()
	ft @= tex(uv,    texture) * weight.x
	ft += tex(v1,    texture) * weight.z
	ft += tex(v1.zw, texture) * weight.y
	ft += tex(v2,    texture) * weight.y
	oc @= tex(v2.zw, texture) * weight.z + ft
