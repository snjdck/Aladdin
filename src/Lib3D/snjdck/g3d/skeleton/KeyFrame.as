package snjdck.g3d.skeleton
{
	import snjdck.g3d.geom.Quaternion;
	
	import vec3.interpolate;

	final public class KeyFrame
	{
		public var time:Number;
		public var transform:Transform;
		
		public function KeyFrame(time:Number, transform:Transform=null)
		{
			this.time = time;
			this.transform = transform || new Transform();
		}
		
		public function interpolate(to:KeyFrame, time:Number, result:Transform):void
		{
			var f:Number = (time - this.time) / (to.time - this.time);
			vec3.interpolate(transform.translation, to.transform.translation, f, result.translation);
			Quaternion.Slerp(transform.rotation, to.transform.rotation, f, result.rotation);
		}
	}
}