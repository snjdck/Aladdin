package snjdck.g3d.bound
{
	import flash.geom.Vector3D;

	public class Rect45
	{
		static public const CONTAINS:int = 1;
		static public const AWAY:int = 2;
		static public const INTERECT:int = 3;
		
		public const center:Vector3D = new Vector3D();
		public var halfWidth:Number;
		public var halfHeight:Number;
		public var halfSize45:Number;
		
		public function Rect45(){}
		
		public function resize($halfWidth:Number, $halfHeight:Number):void
		{
			halfWidth = $halfWidth;
			halfHeight = $halfHeight;
			halfSize45 = Math.SQRT1_2 * (halfWidth + halfHeight);
		}
		
		public function hitTestRect(rectCenter:Vector3D, rectHalfSize:Vector3D):Boolean
		{
			return classify(rectCenter, rectHalfSize.x, rectHalfSize.y) != AWAY;
		}
		
		public function classify(rectCenter:Vector3D, rectHalfWidth:Number, rectHalfHeight:Number):int
		{
			var rectHalfSize45:Number = rectHalfWidth + rectHalfHeight;
			var dx:Number = Math.abs(rectCenter.x - rectCenter.y + center.z) - Math.SQRT2 * halfWidth;
			var dy:Number = Math.abs(rectCenter.x + rectCenter.y + center.w) - Math.SQRT2 * halfHeight
			
			if(-dx >= rectHalfSize45 && -dy >= rectHalfSize45){
				return CONTAINS;
			}
			if(dx >= rectHalfSize45 || dy >= rectHalfSize45){
				return AWAY;
			}
			if(Math.abs(center.x - rectCenter.x) >= rectHalfWidth + halfSize45){
				return AWAY;
			}
			if(Math.abs(center.y - rectCenter.y) >= rectHalfHeight + halfSize45){
				return AWAY;
			}
			return INTERECT;
		}
	}
}