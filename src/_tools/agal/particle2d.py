from agal import *

from shader2d import *

@input(va0="float3")
@const(ScreenMatrix=1, WorldMatrix=2, textureWH=1)
def vertex(op, uv, color):
	vt0, vt1, vt2, vt3 = xt(), xt(), xt(), xt()

	vt3.x = va0.z * 2
	color @= vc[vt3.x:5]
	vt3 @= vc[vt3.x:4]

	vt0.xyw = va0 - (0.5, 0.5, 0, 0)
	vt0.z = 0

	vt1.xy = textureWH * vt3.z
	vt1.z = sin(vt3.w)
	vt1.w = cos(vt3.w)

	vt2.zw = vt1.xxxy * vt1.zzzw
	vt1.z = -vt1.z
	vt2.xy = vt1.xy * vt1.wz

	vt1 @= vt2 * vt0.xyxy
	vt0.xy = vt1.xz + vt1.yw

	vt0.xy += vt3

	mvp2d(op, vt0, vt1)

	uv @= va0

@input(texture=["2d", "linear", "clamp"])
def fragment(oc):
	oc @= tex(uv, texture) * color
