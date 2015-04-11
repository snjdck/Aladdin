package snjdck.gpu.geom
{
	import flash.geom.Vector3D;
	
	import vec3.subtract;

	public class OBB2
	{
		static public const CONTAINS:int = 1;
		static public const AWAY:int = 2;
		static public const INTERECT:int = 3;
		
		public var center:Vector3D;
		public var halfWidth:Number;
		public var halfHeight:Number;
		
		private var _rotation:Number = 0;
		private const xAxis:Vector3D = new Vector3D(1, 0);
		private const yAxis:Vector3D = new Vector3D(0, -1);
		
		public function OBB2()
		{
		}
		
		public function get rotation():Number
		{
			return _rotation;
		}

		public function set rotation(value:Number):void
		{
			_rotation = value;
			var cos:Number = Math.cos(value);
			var sin:Number = Math.sin(value);
			xAxis.setTo(cos, sin, 0);
			yAxis.setTo(sin, -cos, 0);
		}
		
		public function hitTestAABB(other:AABB2):int
		{
			vec3.subtract(other.center, center, ab);
			var dx:Number = absDot(ab, xAxis) - halfWidth;
			var dy:Number = absDot(ab, yAxis) - halfHeight;
			var projWidth:Number = other.getProjLen(xAxis);
			var projHeight:Number = other.getProjLen(yAxis);
			if(-dx >= projWidth && -dy >= projHeight){
				return CONTAINS;
			}
			if(dx >= projWidth || dy >= projHeight){
				return AWAY;
			}
			if(Math.abs(ab.x) >= other.halfWidth + getProjLenX()){
				return AWAY;
			}
			if(Math.abs(ab.y) >= other.halfHeight + getProjLenY()){
				return AWAY;
			}
			return INTERECT;
		}
		
		public function getProjLen(axis:Vector3D):Number
		{
			return halfWidth * absDot(xAxis, axis) + halfHeight * absDot(yAxis, axis);
		}
		
		public function getProjLenX():Number
		{
			return halfWidth * Math.abs(xAxis.x) + halfHeight * Math.abs(yAxis.x);
		}
		
		public function getProjLenY():Number
		{
			return halfWidth * Math.abs(xAxis.y) + halfHeight * Math.abs(yAxis.y);
		}
		
		private function absDot(a:Vector3D, b:Vector3D):Number
		{
			return Math.abs(a.x * b.x + a.y * b.y);
		}
		
		static private const ab:Vector3D = new Vector3D();
	}
}