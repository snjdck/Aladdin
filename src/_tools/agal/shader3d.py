from agal import *

def quaternion(vector):
	vt2.xyz = vt1 * vt1.yzx			#xy,yz,zx
	vt3.xyz = vt1 * vt1.www			#xw,yw,zw
	vt1 **= 2						#xx,yy,zz,ww

	vt4.xyz = vt2.zxy + vt3.yzx		#(zx+yw),(xy+zw),(yz+xw)
	vt3.xyz = vt2.xyz - vt3.zxy		#(xy-zw),(yz-xw),(zx-yw)

	vt2.xyz  = vt1 + vt1.w			#(xx+ww),(yy+ww),(zz+ww)
	vt2.xyz -= vt1.yzx				#(xx+ww-yy),(yy+ww-zz),(zz+ww-xx)
	vt2.xyz -= vt1.zxy				#(xx+ww-yy-zz),(yy+ww-zz-xx),(zz+ww-xx-yy)

	vt2.xyz *= vector.xyz
	vt3.xyz *= vector.yzx
	vt4.xyz *= vector.zxy

	vt1.xyz = vt3.xyz + vt4.xyz
	vt1.xyz *= 2
	vt1.xyz += vt2.xyz

def bone(index):
	vt1 = vc[index]
	quaternion(va0)
	vt1.xyz = vt1 + vc[index:1]

def bone_ani_pos():
	bone(va2.x)
	vt0.xyz = vt1 * va2.y
	bone(va2.z)
	vt1.xyz *= va2.w
	vt0.xyz += vt1
	bone(va3.x)
	vt1.xyz *= va3.y
	vt0.xyz += vt1
	bone(va3.z)
	vt1.xyz *= va3.w
	vt0.xyz += vt1
	vt0.w = va0

def vertex():
	bone_ani_pos()

def fragment():
	pass