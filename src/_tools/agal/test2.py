from agal import *
import ast
import builtins



@input(position="float3", off="float3")
@const(project=1)
def vertex(output, v0, v1):
	t0 = xt()
	t0 @= project
	output @= (1,2,3,4)
	output @= project + t0
	output @= position + off

	v0 @= t0
	v1 @= off

def fragment(output):
	#output @= (1,2,3,4) + v0 + v1
	t0 = xt()
	t0 @= -v0
	t0 @= 0 - v0
	t0 @= 0.0 - v0
	t0 @= 1 / v0
	t0 @= 1.0 / v0
	t0 @= 2 ** v0
	t0 @= 2.0 ** v0
	t0 @= 2 * v0
	t0 @= 2.0 * v0

	t0 @= v1 * 2
	t0 @= v1 * 2.0

	t0 @= v1 ** 2
	t0 @= v1 ** 2.0


#input()