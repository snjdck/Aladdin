package snjdck.g3d
{
	import flash.events.MouseEvent;
	
	import snjdck.g3d.cameras.Camera3D;
	import snjdck.g3d.cameras.ICamera3D;
	import snjdck.g3d.core.DisplayObjectContainer3D;
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.pickup.Ray;
	import snjdck.gpu.IScene;
	import snjdck.gpu.asset.GpuContext;
	
	use namespace ns_g3d;

	final public class Scene3D implements IScene
	{
		public const root:DisplayObjectContainer3D = new DisplayObjectContainer3D();
//		public const camera:Camera3D = new Camera3D();
		
		private const ray:Ray = new Ray();
		
		ns_g3d var _mouseX:Number;
		ns_g3d var _mouseY:Number;
		
		private var _width:int;
		private var _height:int;
		
		private const cameraList:Vector.<ICamera3D> = new Vector.<ICamera3D>();
		
		public function Scene3D()
		{
			root._scene = this;
			root._root = root;
		}
		
		public function update(timeElapsed:int):void
		{
			root.onUpdate(timeElapsed);
			cameraList.length = 0;
			root.traverse(__collectCameras, false);
			for each(var camera:Camera3D in cameraList){
				camera.setScreenSize(_width, _height);
				camera.clear();
				root.collectDrawUnit(camera);
			}
//			camera.update(timeElapsed);
		}
		
		private function __collectCameras(item:Object3D):void
		{
			if(item is ICamera3D){
				cameraList.push(item);
			}
		}
		
		public function draw(context3d:GpuContext):void
		{
			for each(var camera:Camera3D in cameraList){
				camera.draw(context3d);
			}
		}
		
		public function preDrawDepth(context3d:GpuContext):void{}
		
		public function pickup(stageX:Number, stageY:Number, result:Vector.<Object3D>):void
		{
			for each(var camera:Camera3D in cameraList){
				camera.getSceneRay(stageX, stageY, ray);
				camera.pickup(ray, result);
			}
		}
		
		public function notifyEvent(evtType:String):Boolean
		{
			var result:Vector.<Object3D> = new Vector.<Object3D>();
			
			pickup(_mouseX, _mouseY, result);
			
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
		
		public function get mouseX():Number
		{
			return _mouseX;
		}
		
		public function get mouseY():Number
		{
			return _mouseY;
		}
		
		public function resize(width:int, height:int):void
		{
			_width = width;
			_height = height;
		}
		
		public function get stageWidth():int
		{
			return _width;
		}
		
		public function get stageHeight():int
		{
			return _height;
		}
	}
}