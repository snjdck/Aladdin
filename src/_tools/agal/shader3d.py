from agal import *

va(position=FLOAT_3, bone1=FLOAT_4, bone2=FLOAT_4)

def rotate(vector, quaternion):
	t1 = quaternion
	t2, t3, t4 = vt(), vt(), vt()
	t2.xyz = t1 * t1.yzx			#xy,yz,zx
	t3.xyz = t1 * t1.www			#xw,yw,zw
	t1 @= t1 ** 2					#xx,yy,zz,ww

	t4.xyz = t2.zxy + t3.yzx		#(zx+yw),(xy+zw),(yz+xw)
	t3.xyz = t2.xyz - t3.zxy		#(xy-zw),(yz-xw),(zx-yw)

	t2.xyz  = t1 + t1.w				#(xx+ww),(yy+ww),(zz+ww)
	t2.xyz -= t1.yzx				#(xx+ww-yy),(yy+ww-zz),(zz+ww-xx)
	t2.xyz -= t1.zxy				#(xx+ww-yy-zz),(yy+ww-zz-xx),(zz+ww-xx-yy)

	t2.xyz *= vector.xyz
	t3.xyz *= vector.yzx
	t4.xyz *= vector.zxy

	t1.xyz = t3.xyz + t4.xyz
	t1.xyz *= 2
	t1.xyz += t2.xyz

def bone(index):
	t1 = vt()
	t1 @= vc[index]
	rotate(position, t1)
	t1.xyz += vc[index:1]
	return t1

def bone_ani_pos(t0):
	t1 = bone(bone1.x)
	t0.xyz = t1 * bone1.y
	del t1
	for index in (bone1.z, bone2.x, bone2.z):
		t1 = bone(index)
		t1.xyz *= next(index)
		t0.xyz += t1
		del t1

def vertex():
	t0 = vt()
	bone_ani_pos(t0)
	t0.w = position

def fragment():
	pass