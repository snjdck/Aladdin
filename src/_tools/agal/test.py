from agal import *

def vertex_():
	vt[1] = dp4(vt[1], vt[2]).zw
	vt[1].x = dp4(vt[1], vt[2]).y
	vt[0].x = vt[3] + vt[1]
	vt[0] = vt[3].z

	vt[0] += vt[1]
	vt[0].x += vt[2]

	vt[1] -= vt[1]
	vt[1].x -= vt[2]


	vt[2] *= vt[1]
	vt[2].x *= vt[2]


	vt[3] /= vt[1]
	vt[3].x /= vt[2]


	vt[3] **= vt[1]
	vt[3].x **= vt[2]



	vt[0] = vt[1].x + vt[2] * vt[3]
	vt[0] = vt[1].x - vt[2]
	vt[0] = vt[1].x * vt[2]
	vt[0] = vt[1].x / vt[2]
	vt[0] = vt[1].x ** vt[2]



	vt[0] = - vt[0].y

	vt[0] = (((vt[1] + vt[2]) * (vt[1] + vt[2])) * ((vt[1] + vt[2]) * (vt[1] + vt[2])).z).w

	vt[0] = vt[2] + dp4(vt[1] + vt[2], vt[3] + vt[4])

	vt[3] = (vt[0] == vc[0]) + (vt[1] != vc[1])
	vt[3] = (vt[0] >= vc[0]) + (vt[1] < vc[1])
	vt[3] = (vt[0] <= vc[0]) + (vt[1] > vc[1])
	v[0] = va[0]

def fragment_():
	t = v[0]
	t1 = v[0].xy
	ft[0] = t + fc[0]
	t = ft[1]
	t.xy = ft[1]
	t.xy = t1
	t1 = v[0]

	ft[0] = m33(ft[0] * vc[2], ft[0] + vc[2])
	kil(ft[0].x)
	ft[3] = abs(m33(ft[0] * vc[2], ft[0] + vc[2]))

	for i in range(3):
		ft[i] = aa(ft[i] * ft[2], fc[3])

def aa(a, b):
	return a + b * ft[2]


vc[0] = (1,2,3,4)
position = va[0]
final_position = vt[2]
offset = vc[1]


def vertex():
	vt[0] = vc[1] * position + final_position
	final_position = position

def fragment():
	pass


run(vars())