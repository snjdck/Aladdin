from agal import *

from shader2d import *

@input(va0="float3")
@const(ScreenMatrix=1, WorldMatrix=2, fontW_charW=1)
def vertex(op, uv):
	vt0 = xt()
	vt0 @= va0.xyxy * fontW_charW.xxyy
	vt0 += vc[va0.z:4]
	uv @= vt0.zw
	vt0.zw = (None, None, 0, 1)
	mvp2d(op, vt0, xt())

@input(texture=["2d", "linear", "clamp"])
@const(color=1)
def fragment(oc):
	ft0 = xt()
	ft0 @= tex(uv, texture)
	oc.xyz = color
	oc.w   = ft0.w * color.w
