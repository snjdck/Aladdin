package snjdck.g3d
{
	import flash.events.MouseEvent;
	
	import snjdck.g3d.core.Camera3D;
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.pickup.Ray;
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
		
		public function Scene3D(){}
		
		public function update(timeElapsed:int):void
		{
			root.onUpdate(timeElapsed);
			collector.clear();
			root.collectDrawUnit(collector);
			camera.update();
		}
		
		public function draw(context3d:GpuContext):void
		{
			collector.render(context3d, camera);
		}
		
		public function pickup(screenX:Number, screenY:Number, result:Vector.<Object3D>):void
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
		
		public function notifyEvent(evtType:String, screenX:Number, screenY:Number):Boolean
		{
			var result:Vector.<Object3D> = new Vector.<Object3D>();
			
			pickup(screenX, screenY, result);
			
			for each(var target:Object3D in result){
				switch(evtType){
					case MouseEvent.MOUSE_DOWN:
						target.mouseDownSignal.notify();
						break;
					case MouseEvent.MOUSE_UP:
						break;
				}
			}
			return result.length > 0;
		}
	}
}