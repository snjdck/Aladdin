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
		public const camera:Camera3D = new Camera3D();
		
		private const collector:DrawUnitCollector3D = new DrawUnitCollector3D();
		
		private const ray:Ray = new Ray();
		
		ns_g3d var _mouseX:Number;
		ns_g3d var _mouseY:Number;
		
		public function Scene3D(){}
		
		public function update(timeElapsed:int):void
		{
			root.onUpdate(timeElapsed);
			collector.clear();
			root.collectDrawUnit(collector);
			camera.update();
			if(camera.enableViewFrusum){
				collector.cullInvisibleUnits(camera);
			}
		}
		
		public function draw(context3d:GpuContext):void
		{
			if(collector.hasDrawUnits()){
				camera.uploadMVP(context3d);
				collector.render(context3d, camera);
			}
		}
		
		public function preDrawDepth(context3d:GpuContext):void
		{
			if(collector.hasDrawUnits()){
				camera.uploadMVP(context3d);
				collector.preDrawDepth(context3d, camera);
			}
		}
		
		public function pickup(stageX:Number, stageY:Number, result:Vector.<Object3D>):void
		{
			camera.getSceneRay(stageX, stageY, ray);
			root.hitTest(ray, result);
		}
		
		public function notifyEvent(evtType:String, stageX:Number, stageY:Number):Boolean
		{
			var result:Vector.<Object3D> = new Vector.<Object3D>();
			
			pickup(stageX, stageY, result);
			
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
		
		public function addChild(child:Object3D):void
		{
			root.addChild(child);
		}
		
		public function findChild(childName:String):Object3D
		{
			return root.findChild(childName);
		}
		
		public function get mouseX():Number
		{
			return _mouseX;
		}
		
		public function get mouseY():Number
		{
			return _mouseY;
		}
	}
}