package snjdck.g3d.renderer
{
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.pickup.Ray;
	import snjdck.gpu.asset.GpuContext;
	
	public class DrawUnit3D implements IDrawUnit3D
	{
		private var _target:Object3D;
		private var _tag:uint;
		
		public function DrawUnit3D(target:Object3D)
		{
			_target = target;
		}
		
		public function get target():Object3D
		{
			return _target;
		}
		
		public function get tag():uint
		{
			return _tag;
		}
		
		public function set tag(value:uint):void
		{
			_tag = value;
		}
		
		public function draw(context3d:GpuContext):void
		{
		}
		
		public function hitTest(worldRay:Ray, result:Vector.<Object3D>):void
		{
		}
	}
}