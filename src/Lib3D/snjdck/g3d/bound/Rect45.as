package snjdck.g3d.bound
{
	import flash.geom.Vector3D;

	public class Rect45
	{
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
			var rectHalfSize45:Number = rectHalfSize.x + rectHalfSize.y;
			if(Math.abs(rectCenter.x - rectCenter.y + center.z) >= rectHalfSize45 + halfWidth * Math.SQRT2){
				return false;
			}
			if(Math.abs(rectCenter.x + rectCenter.y + center.w) >= rectHalfSize45 + halfHeight * Math.SQRT2){
				return false;
			}
			if(Math.abs(center.x - rectCenter.x) >= rectHalfSize.x + halfSize45){
				return false;
			}
			if(Math.abs(center.y - rectCenter.y) >= rectHalfSize.y + halfSize45){
				return false;
			}
			return true;
		}
	}
}