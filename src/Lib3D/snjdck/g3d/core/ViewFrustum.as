package snjdck.g3d.core
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import snjdck.g3d.geom.Bound;
	import snjdck.g3d.geom.Plane3D;

	public class ViewFrustum
	{
		private var aabbPoints:Vector.<Number>;
		
		private var left:Plane3D;
		private var right:Plane3D;
		private var top:Plane3D;
		private var bottom:Plane3D;
		private var near:Plane3D;
		private var far:Plane3D;
		
		public function ViewFrustum()
		{
			aabbPoints = new Vector.<Number>(24, true);
			
			left = new Plane3D();
			right = new Plane3D();
			top = new Plane3D();
			bottom = new Plane3D();
			near = new Plane3D();
			far = new Plane3D();
		}
		
		public function update(mvp:Matrix3D):void
		{
			mvp.copyRawDataTo(tempRawData);
			
			const c11:Number=tempRawData[0], c12:Number=tempRawData[4], c13:Number=tempRawData[8], c14:Number=tempRawData[12];
			const c21:Number=tempRawData[1], c22:Number=tempRawData[5], c23:Number=tempRawData[9], c24:Number=tempRawData[13];
			const c31:Number=tempRawData[2], c32:Number=tempRawData[6], c33:Number=tempRawData[10],c34:Number=tempRawData[14];
			const c41:Number=tempRawData[3], c42:Number=tempRawData[7], c43:Number=tempRawData[11],c44:Number=tempRawData[15];
			
			left.setTo(c41+c11, c42+c12, c43+c13, c44+c14);
			left.normalize();
			right.setTo(c41-c11, c42-c12, c43-c13, c44-c14);
			right.normalize();
			bottom.setTo(c41+c21, c42+c22, c43+c23, c44+c24);
			bottom.normalize();
			top.setTo(c41-c21, c42-c22, c43-c23, c44-c24);
			top.normalize();
			near.setTo(c31, c32, c33, c34);
			near.normalize();
			far.setTo(c41-c31, c42-c32, c43-c33, c44-c34);
			far.normalize();
		}
		
		public function isBoundVisible(bound:Bound, matrix:Matrix3D):Boolean
		{
			return isSphereVisible(matrix.position, bound.radius) && isBoxVisible(bound, matrix);
		}
		
		private function isSphereVisible(pos:Vector3D, radius:Number):Boolean
		{
			var negRadius:Number = -radius;
			if(left.distance(pos) <= negRadius)	return false;
			if(right.distance(pos) <= negRadius)	return false;
			if(bottom.distance(pos) <= negRadius)	return false;
			if(top.distance(pos) <= negRadius)	return false;
			if(near.distance(pos) <= negRadius)	return false;
			if(far.distance(pos) <= negRadius)	return false;
			return true;
		}
		
		private function isPointVisible(pt:Vector3D):Boolean
		{
			return isSphereVisible(pt, 0);
		}
		
		private function isBoxVisible(bound:Bound, matrix:Matrix3D):Boolean
		{
			bound.transform(matrix, aabbPoints);
			
			for(var i:int=0; i<aabbPoints.length; i+=3){
				tempPoint.setTo(aabbPoints[i], aabbPoints[i+1], aabbPoints[i+2]);
				if(isPointVisible(tempPoint)){
					return true;
				}
			}
			
			return false;
		}
		
		static private const tempRawData:Vector.<Number> = new Vector.<Number>(16, true);
		static private const tempPoint:Vector3D = new Vector3D();
	}
}