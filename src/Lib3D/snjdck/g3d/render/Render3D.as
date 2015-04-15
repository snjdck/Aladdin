package snjdck.g3d.render
{
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.pickup.RayCastStack;
	import snjdck.g3d.pickup.RayTestInfo;
	import snjdck.gpu.asset.GpuContext;
	
	use namespace ns_g3d;

	public class Render3D
	{
		private const collector:DrawUnitCollector3D = new DrawUnitCollector3D();
		
		private const rayCastStack:RayCastStack = new RayCastStack();
		
		public function Render3D(){}
		
		public function draw(scene3d:Object3D, context3d:GpuContext):void
		{
			collector.clear();
			scene3d.collectDrawUnit(collector);
			collector.root = scene3d;
			
			for each(var camera3d:CameraUnit3D in collector.cameraList){
				camera3d.render(this, collector, context3d);
			}
		}
		
		public function pickup(screenX:Number, screenY:Number, result:Vector.<RayTestInfo>):void
		{
			for each(var camera3d:CameraUnit3D in collector.cameraList)
			{
				if(camera3d.mouseEnabled){
					camera3d.getSceneRay(screenX, screenY, rayCastStack.ray);
					collector.root.hitTest(rayCastStack, result);
				}
			}
		}
	}
}