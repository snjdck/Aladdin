package snjdck.g3d
{
	import snjdck.g3d.core.Camera3D;
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.pickup.Ray;
	import snjdck.g3d.pickup.RayTestInfo;
	import snjdck.g3d.render.DrawUnitCollector3D;
	import snjdck.gpu.IScene;
	import snjdck.gpu.asset.GpuContext;
	
	use namespace ns_g3d;

	public class Scene3D implements IScene
	{
		public const root:Object3D = new Object3D();
		public var camera:Camera3D;
		
		private const collector:DrawUnitCollector3D = new DrawUnitCollector3D();
		
		private const ray:Ray = new Ray();
		
		public function Scene3D()
		{
		}
		
		public function update(timeElapsed:int):void
		{
			root.onUpdate(timeElapsed);
			collector.clear();
			root.collectDrawUnit(collector);
			camera.update();
		}
		
		public function draw(context3d:GpuContext):void
		{
			camera.render(collector, context3d);
		}
		
		public function pickup(screenX:Number, screenY:Number, result:Vector.<RayTestInfo>):void
		{
			camera.getSceneRay(screenX, screenY, ray);
			root.hitTest(ray, result);
		}
		
		public function addChild(child:Object3D):void
		{
			root.addChild(child);
		}
		
		public function findChild(childName:String):Object3D
		{
			return root.findChild(childName);
		}
	}
}