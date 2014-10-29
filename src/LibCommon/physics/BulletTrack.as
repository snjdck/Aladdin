package physics
{
	import flash.geom.Vector3D;
	
	import stdlib.constant.Unit;

	public class BulletTrack
	{
		static public function CalcFireAngle(p1:Vector3D, p2:Vector3D, speed:Number):Number
		{
			var x:Number = p2.x - p1.x;
			var y:Number = p2.y - p1.y;
			
			var v2:Number = speed * speed;
			var gx:Number = Unit.G * x;
			var gy:Number = Unit.G * y;
			
			var delta:Number = v2 * (v2 - 2 * gy) - gx * gx;
			
			if(delta < 0){
				return 0;
			}else if(delta == 0){
				return Math.atan(v2/gx);
			}
			var t1:Number = Math.atan((v2-Math.sqrt(delta))/gx);
			var t2:Number = Math.atan((v2+Math.sqrt(delta))/gx);
			return t1;
		}
	}
}