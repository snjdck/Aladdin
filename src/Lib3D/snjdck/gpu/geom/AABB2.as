package snjdck.gpu.geom
{
	import flash.geom.Vector3D;

	public class AABB2
	{
		public var center:Vector3D;
		public var halfWidth:Number;
		public var halfHeight:Number;
		
		public function AABB2()
		{
		}
		
		public function getProjLen(axis:Vector3D):Number
		{
			return halfWidth * Math.abs(axis.x) + halfHeight * Math.abs(axis.y);
		}
	}
}