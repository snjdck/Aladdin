from agal import *

begin(__file__)

vt[1] = dp4(vt[1], vt[2])
vt[0].x = vt[3] + vt[1]
vt[0] = vt[4].z

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



vt[0] = -vt[0].y


end()
input()