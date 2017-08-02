from agal import *

include("shader2d", globals())

@input(position="float3")
#@const(matrix=4)
def vertex(op):
	vt0 = xt()
	vt0 @= 0
	vt0 @= vc[vt0.x]
	op @= position
	
#@input(texture=["2d", "linear", "test", "fuck"])
def fragment(oc):
	oc @= (0,1,1,1)