from agal import *

from shader2d import *

@input(position="float2", normal="float2")
@const(ScreenMatrix=1, WorldMatrix=2, FrameMatrix=1, UVMatrix=1, WMatrix=1, MMatrix=1)
def vertex(output, uv):
	vt1 = image(output)
	uv @= vt1.zw

@input(texture=["2d", "linear", "clamp"])
@const(matrix=4, offset=1)
def fragment(oc):
	oc @= m44(tex(uv, texture), matrix) + offset
