package snjdck.g3d.geom
{
	import flash.geom.Matrix3D;
	import flash.geom.Orientation3D;
	import flash.geom.Vector3D;
	import flash.lang.ISerializable;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;

	/**
	 * 四元数
	 * i^2 = j^2 = k^2 = -1
	 * ij=k=-ji
	 * jk=i=-kj
	 * ki=j=-ik
	 * 不满足乘法交换率
	 */
	final public class Quaternion implements ISerializable
	{
		static public const Null:Quaternion = new Quaternion();
		
		static public function Slerp(a:Quaternion, b:Quaternion, percent:Number, result:Quaternion):void
		{
			var x1:Number = a.x, y1:Number = a.y, z1:Number = a.z, w1:Number = a.w;
			var x2:Number = b.x, y2:Number = b.y, z2:Number = b.z, w2:Number = b.w;
			
			var dot:Number = x1*x2 + y1*y2 + z1*z2 + w1*w2;
			
			if(dot < 0){
				dot = -dot;
				x2 = -x2;
				y2 = -y2;
				z2 = -z2;
				w2 = -w2;
			}
			
			if(dot < 0.95){//正常插值
				var angle:Number = Math.acos(dot);
				var s:Number = 1 / Math.sin(angle);
				var s1:Number = s * Math.sin(angle * (1 - percent));
				var s2:Number = s * Math.sin(angle * percent);
				
				result.x = x1*s1 + x2*s2;
				result.y = y1*s1 + y2*s2;
				result.z = z1*s1 + z2*s2;
				result.w = w1*s1 + w2*s2;
			}else{//线性插值
				result.x = x1 + (x2-x1) * percent;
				result.y = y1 + (y2-y1) * percent;
				result.z = z1 + (z2-z1) * percent;
				result.w = w1 + (w2-w1) * percent;
				
				result.normalize();
			}
		}
		
		static public function FromMatrix(matrix:Matrix3D):Quaternion
		{
			var v:Vector3D = matrix.decompose(Orientation3D.QUATERNION)[1];
			return new Quaternion(v.x, v.y, v.z, v.w);
		}
		
		static public function FromAxisAngle(axis:Vector3D, angle:Number):Quaternion
		{
			var halfAngle:Number = angle * 0.5;
			var sin:Number = Math.sin(halfAngle);
			
			return new Quaternion(
				axis.x * sin,
				axis.y * sin,
				axis.z * sin,
				Math.cos(halfAngle)
			);
		}
		
		public var x:Number;
		public var y:Number;
		public var z:Number;
		public var w:Number;
		
		public function Quaternion(x:Number=0, y:Number=0, z:Number=0, w:Number=1)
		{
			setTo(x, y, z, w);
		}
		
		[Inline]
		public function setTo(vx:Number, vy:Number, vz:Number, vw:Number):void
		{
			this.x = vx;
			this.y = vy;
			this.z = vz;
			this.w = vw;
		}
		
		[Inline]
		public function copyFrom(from:Quaternion):void
		{
			setTo(from.x, from.y, from.z, from.w);
		}
		
		public function clone():Quaternion
		{
			return new Quaternion(x, y, z, w);
		}
		
		/** 共轭 */
		public function getConjugate():Quaternion
		{
			return new Quaternion(-x, -y, -z, w);
		}
		
		public function normalize():void
		{
			var factor:Number = 1 / Math.sqrt(x*x + y*y + z*z + w*w);
			this.x *= factor;
			this.y *= factor;
			this.z *= factor;
			this.w *= factor;
		}
		
		/**
		 * 单位:弧度
		 * @param pitch		俯仰,欧拉角向量的x轴
		 * @param yaw		偏航,欧拉角向量的y轴
		 * @param roll		翻滚,欧拉角向量的z轴
		 */
		public function fromEulerAngles(pitch:Number, yaw:Number, roll:Number):void
		{
			var halfX:Number = 0.5 * pitch;
			var halfY:Number = 0.5 * yaw;
			var halfZ:Number = 0.5 * roll;
			
			var sinX:Number = Math.sin(halfX);
			var cosX:Number = Math.cos(halfX);
			
			var sinY:Number = Math.sin(halfY);
			var cosY:Number = Math.cos(halfY);
			
			var sinZ:Number = Math.sin(halfZ);
			var cosZ:Number = Math.cos(halfZ);
			
			this.x = sinX*cosY*cosZ - cosX*sinY*sinZ;
			this.y = sinY*cosZ*cosX + cosY*sinZ*sinX;
			this.z = sinZ*cosX*cosY - cosZ*sinX*sinY;
			this.w = cosX*cosY*cosZ + sinX*sinY*sinZ;
		}
		
		public function toEulerAngles(result:Vector3D):void
		{
			result.x = Math.atan2(2*(w*x+y*z), 1-2*(x*x+y*y));
			result.y = Math.asin( 2*(w*y-x*z));
			result.z = Math.atan2(2*(w*z+y*x), 1-2*(z*z+y*y));
		}
		
		public function toAxisAngle(result:Vector3D):void
		{
			if(1 == w)
			{
				result.x = 1;
				result.y = 0;
				result.z = 0;
				result.w = 0;
				return;
			}
			
			var halfAngle:Number = Math.acos(w);
			var factor:Number = 1 / Math.sin(halfAngle);
			
			result.x = x * factor;
			result.y = y * factor;
			result.z = z * factor;
			result.w = 2 * halfAngle;
		}
		
		/**
		 * 满足结合律 abc = (ab)c = a(bc)
		 * 满足分配率 c(a+b) = ca+cb
		 * AB = (a0 + a1.i + a2.j + a3.k)*(b0 + b1.i + b2.j + b3.k)
		 *    = (a0*b0 - a1*b1 - a2*b2 - a3*b3) + (a0*b1 + a1*b0).i + (a0*b2 + a2*b0).j + (a0*b3 + a3*b0).k
		 *     + a1*b2.ij + a1*b3.ik + a2*b1.ji + a2*b3.jk + a3*b1.ki + a3*b2.kj
		 *    = (a0*b0 - a1*b1 - a2*b2 - a3*b3) // a0*b0 - 向量部分的点乘 + 向量部分的叉乘 + a0* bv + b0 * av
		 *     + (a0*b1 + a1*b0 + a2*b3 - a3*b2).i
		 *     + (a0*b2 - a1*b3 + a2*b0 + a3*b1).j
		 *     + (a0*b3 + a1*b2 - a2*b1 + a3*b0).k
		 */
		[Inline]
		public function multiply(other:Quaternion, result:Quaternion):void
		{
			var tx:Number = (this.w * other.x) + (this.x * other.w) + (this.y * other.z) - (this.z * other.y);
			var ty:Number = (this.w * other.y) - (this.x * other.z) + (this.y * other.w) + (this.z * other.x);
			var tz:Number = (this.w * other.z) + (this.x * other.y) - (this.y * other.x) + (this.z * other.w);
			var tw:Number = (this.w * other.w) - (this.x * other.x) - (this.y * other.y) - (this.z * other.z);
			
			result.x = tx;
			result.y = ty;
			result.z = tz;
			result.w = tw;
		}
		
		/**
		 * multiply(new Quaternion(v.x, v.y, v.z, 0)).multiply(getConjugate());
		 */
		public function rotateVector(v:Vector3D, result:Vector3D):void
		{
			//复制区域--begin
			var xx:Number = x*x;
			var yy:Number = y*y;
			var zz:Number = z*z;
			var ww:Number = w*w;
			
			var xy2:Number = 2*x*y;
			var xz2:Number = 2*x*z;
			var xw2:Number = 2*x*w;
			var yz2:Number = 2*y*z;
			var yw2:Number = 2*y*w;
			var zw2:Number = 2*z*w;
			//复制区域--end
			
			var tx:Number = v.x * (xx + ww - yy - zz) + v.y * (xy2 - zw2) + v.z * (xz2 + yw2);
			var ty:Number = v.y * (yy + ww - zz - xx) + v.z * (yz2 - xw2) + v.x * (xy2 + zw2);
			var tz:Number = v.z * (zz + ww - xx - yy) + v.x * (xz2 - yw2) + v.y * (yz2 + xw2);
			
			result.x = tx;
			result.y = ty;
			result.z = tz;
		}
		
		public function toMatrix(result:Matrix3D, translation:Vector3D=null):void
		{
			//复制区域--begin
			var xx:Number = x*x;
			var yy:Number = y*y;
			var zz:Number = z*z;
			var ww:Number = w*w;
			
			var xy2:Number = 2*x*y;
			var xz2:Number = 2*x*z;
			var xw2:Number = 2*x*w;
			var yz2:Number = 2*y*z;
			var yw2:Number = 2*y*w;
			var zw2:Number = 2*z*w;
			//复制区域--end
			
			rawData[0] = xx + ww - yy - zz;
			rawData[4] = xy2 - zw2;
			rawData[8] = xz2 + yw2;
			
			rawData[1] = xy2 + zw2;
			rawData[5] = yy + ww - zz - xx;
			rawData[9] = yz2 - xw2;
			
			rawData[2] = xz2 - yw2;
			rawData[6] = yz2 + xw2;
			rawData[10] = zz + ww - xx - yy;
			
			if(translation){
				rawData[12] = translation.x;
				rawData[13] = translation.y;
				rawData[14] = translation.z;
			}else{
				rawData[12] = rawData[13] = rawData[14] = 0;
			}
			/*
			if(scale){
				rawData[0] *= scale.x;
				rawData[5] *= scale.y;
				rawData[10] *= scale.z;
			}
			//*/
			result.copyRawDataFrom(rawData);
		}
		
		public function readFrom(buffer:IDataInput):void
		{
			setTo(buffer.readFloat(), buffer.readFloat(), buffer.readFloat(), buffer.readFloat());
		}
		
		public function writeTo(buffer:IDataOutput):void
		{
			buffer.writeFloat(x);
			buffer.writeFloat(y);
			buffer.writeFloat(z);
			buffer.writeFloat(w);
		}
		
		static private const rawData:Vector.<Number> = new <Number>[
			0, 0, 0, 0,
			0, 0, 0, 0,
			0, 0, 0, 0,
			0, 0, 0, 1
		];
	}
}