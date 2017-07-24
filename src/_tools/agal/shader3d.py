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

def vertex():
	quaternion(va0)

def fragment():
	pass