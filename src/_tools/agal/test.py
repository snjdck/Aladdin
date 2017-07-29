from agal import *
#import test2

@input(position="float3")
@const(matrix=4, offset=1)
def vertex(output):
	vt0, vt1, vt2, vt3, vt4 = xt(), xt(), xt(), xt(), xt()

	vt1 @= dp4(vt1, position).zw
	vt1.x = dp4(vt1, vt2).y
	vt0.x = vt3 + vt1
	vt0 @= vt3.z

	vt0 += vt1
	vt0.x += vt2

	vt1 -= vt1
	vt1.x -= vt2


	vt2 *= vt1
	vt2.x *= vt2


	vt3 /= vt1
	vt3.x /= vt2


	vt3 **= vt1
	vt3.x **= vt2



	vt0 @= vt1.x + vt2 * vt3
	vt0 @= vt1.x - vt2
	vt0 @= vt1.x * vt2
	vt0 @= vt1.x / vt2
	vt0 @= vt1.x ** vt2



	vt0 @= - vt0.y

	vt0 @= (((vt1 + vt2) * (vt1 + vt2)) * ((vt1 + vt2) * (vt1 + vt2)).z).w

	vt0 @= vt2 + dp4(vt1 + vt2, vt3 + vt4)

	vt3 @= (vt0 == matrix) + (vt1 != matrix)
	vt3 @= (vt0 >= matrix) + (vt1 < matrix)
	vt3 @= (vt0 <= matrix) + (vt1 > matrix)
	return position
	#va[0] = vt0

@const(matrix=4, offset=1)
def fragment(output, v0):
	ft0, ft1, ft2, ft3 = xt(), xt(), xt(), xt()
	ft = [ft0, ft1, ft2, ft3]
	t = v0
	t1 = v0.xy
	ft0 @= t + matrix
	t @= ft1
	t.xy = ft1
	t.xy = t1
	t1 @= v0

	ft0 @= m33(ft0 * matrix, ft0 + matrix)
	kil(ft0.x)
	ft3 @= abs(m33(ft0 * matrix, ft0 + matrix))

	for i in range(3):
		ft[i] @= aa(ft[i] * ft2, matrix)

def aa(a, b):
	return a + b * xt()








#fc[0] = (1,2,3,4)





"""
def vertex():
	vt0 = vc[va0.x] + vt2
	vt0 = vc[va0.x:1]
	vt1 = vc[va0.x].x
	vt0 = vc[va0.x:1].y
	vt0 = tex(v[0], fs[0]("2d", "linear"))
	op[0] = (1,2,3,4) * vt0 * vt7
	#vt1 = vc[va0.x].x
	'''
	vt0 = va0.x
	va0.x = vt1
	va0 = vt1
	vt0 = va0
	vt0 = vc[1] * position + final_position
	final_position = position
	'''

def fragment():
	vt0 = min(vt0, vt1)

	#vt0.x = 5 >= v0
	vt0.x = v0 + 5
	ife(vt0.x)
	vt0 = ddx((v0 + 5).x)
	els()
	eif()
	vt0 = 0.0 - vt1
	vt0 = 1.0 - vt1

	vt0 = 1.0 / vt1
	vt0 = 2.0 / vt1

	vt0 = 2.0 ** vt1
	vt0 = 3.0 ** vt1

	vt0 = vt1 * 2
	vt0 = 2 * (vt2 ** vc[0]).x
	#vt0.x = (v0 + 5) * 2 / 6+ 8 +9
	oc[0].x = 0
	ffff()
	ft0 = ft0
	a = ft0
	a @= ft1

def ffff():
	vt1 = vt0 + vc0
	oc = ft0 + oc[0] + oc0
"""

#run(vars())