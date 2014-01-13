package snjdck.g3d.geom
{
	import flash.geom.Vector3D;
	
	import snjdck.g3d.core.Object3D;

	public class RayTestInfo
	{
		public var target:Object3D;
		
		public var u:Number;
		public var v:Number;
		public var t:Number;
		
		public var localPos:Vector3D;
		
		public function RayTestInfo()
		{
		}
		
		public function get globalPos():Vector3D
		{
			return target.localToGlobal(localPos);
		}
	}
}