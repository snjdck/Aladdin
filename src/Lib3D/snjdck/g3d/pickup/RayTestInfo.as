package snjdck.g3d.pickup
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
		
		/**
		 * 相机空间位置，用于鼠标拾取z排序
		 */		
		public var globalPos:Vector3D;
		
		public function RayTestInfo()
		{
		}
	}
}