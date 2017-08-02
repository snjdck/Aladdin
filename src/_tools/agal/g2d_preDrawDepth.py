from agal import *

@input(va0="float3")
@const(ScreenMatrix=1)
def vertex(op):
	vt0 = xt()
	vt0 @= vc[va0.z:4]
	vt0.xy *= va0
	vt0.xy += vt0.zw
	vt0.xy *= ScreenMatrix
	vt0.xy += ScreenMatrix.zw
	vt0.zw = (None, None, 0, 1)
	op @= vt0

def fragment(oc):
	oc @= any