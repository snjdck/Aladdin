from agal import *



def rotate(vector, quaternion):
	t1 = quaternion
	t2, t3, t4 = xt(), xt(), xt()
	t2.xyz = t1 * t1.yzx			#xy,yz,zx
	t3.xyz = t1 * t1.www			#xw,yw,zw
	t1 **= 2						#xx,yy,zz,ww

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
	t1 = xt()
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

def bone_ani_normal(t0):
	t1 = xt()
	t1 @= vc[bone1.x]
	rotate(normal, t1)
	t0.xyz = t1 * bone1.y
	for index in (bone1.z, bone2.x, bone2.z):
		t1 @= vc[index]
		rotate(normal, t1)
		t1.xyz *= next(index)
		t0.xyz += t1

def camera3d(t0):
	t0.xyz = m34(t0, CameraMatrix)
	t1 = xt()
	#t0.z = t0 - 

@input(position="float3", normal="float3", bone1="float4", bone2="float4")
@const(ProjectionMatrix=2, CameraMatrix=2, WorldMatrix=3)
def vertex(output):
	t0 = xt()
	bone_ani_pos(t0)
	t0.w = position
	bone_ani_normal(t0)

def fragment(output):
	pass