from agal import *
import ast
import builtins



@input(position="float3", off="float3")
@const(project=1)
def vertex(output):
	t0 = xt()
	t0 @= project
	output @= (1,2,3,4)
	output @= project + t0
	output @= position + off
	return t0, off

def fragment(output, v0, v1):
	output @= (1,2,3,4) + v0 + v1


#input()