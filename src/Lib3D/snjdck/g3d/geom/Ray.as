package snjdck.g3d.geom
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import math.nearEquals;
	
	import vec3.crossProd;
	import vec3.subtract;
	
	/**
	 * todo test bound volume, bound sphere
	 */	
	public class Ray
	{
		private var pos:Vector3D;
		private var dir:Vector3D;
		
		public function Ray(pos:Vector3D=null, dir:Vector3D=null)
		{
			this.pos = pos;
			this.dir = dir;
		}
		
		/** 将射线变换到本地坐标 */
		public function transformToLocal(localToRayMatrix:Matrix3D):Ray
		{
			tempMatrix.copyFrom(localToRayMatrix);
			tempMatrix.invert();
			
			return new Ray(tempMatrix.transformVector(pos), tempMatrix.deltaTransformVector(dir));
		}
		
		private function getPt(t:Number):Vector3D
		{
			var result:Vector3D = dir.clone();
			result.scaleBy(t);
			result.incrementBy(pos);
			return result;
		}
		
		/**
		 * result.x = u
		 * result.y = v
		 * result.z = t
		 */
		public function testTriangle(v0:Vector3D, v1:Vector3D, v2:Vector3D, result:RayTestInfo):Boolean
		{
			vec3.subtract(v1, v0, e1);
			vec3.subtract(v2, v0, e2);
			vec3.crossProd(dir, e2, p);
			
			var det:Number = e1.dotProduct(p);
			
			if(nearEquals(0, det)){//射线在平面上
				return false;
			}
			
			if(det > 0){
				vec3.subtract(pos, v0, t);
			}else{
				vec3.subtract(v0, pos, t);
				det = -det;
			}
			
			const u:Number = t.dotProduct(p);
			
			if(u < 0 || det < u){
				return false;
			}
			
			vec3.crossProd(t, e1, q);
			
			const v:Number = dir.dotProduct(q);
			
			if(v < 0 || det < u+v){
				return false;
			}
			
			det = 1 / det;
			
			result.u = det * u;
			result.v = det * v;
			result.t = det * e2.dotProduct(q);
			result.localPos = getPt(result.t);
			
			return true;
		}
		
		static private const e1:Vector3D = new Vector3D();
		static private const e2:Vector3D = new Vector3D();
		
		static private const p:Vector3D = new Vector3D();
		static private const t:Vector3D = new Vector3D();
		static private const q:Vector3D = new Vector3D();
		
		static private const tempMatrix:Matrix3D = new Matrix3D();
	}
}