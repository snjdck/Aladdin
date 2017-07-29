from agal import *

@input(position="float3", normal="float2")
@const(matrix=4, matrixA=4)
def vertex(output):
	print(position.value(), normal.value(), matrix.value())
	t0 = xt()
	t1 = xt()
	t0 @= position
	v0 = matrix
	v1 = matrixA
	v0 = (1,2,3,4)
	op = t1 + t0 * (1,2,3,4)
	op = t0 * (2,6)
	op = t0 * (1.3, 1, 1, 1.3)
	op = t0 * 3
	op = t0 * (2,3,3,1)
	op = t0 * (None, 2, 3)
	op = t0 * (3,2)
	op = t0 * (1,2,3,4)
	op = t0 * (None,1,None,7)
	op = t0 * 0.7
	
@input(texture=["2d", "linear"])
def fragment(output):
	t0 = xt()
	oc = tex(t0, texture)