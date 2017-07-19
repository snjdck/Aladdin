package snjdck.g3d
{
	import flash.events.MouseEvent;
	
	import snjdck.g3d.cameras.Camera3D;
	import snjdck.g3d.core.DisplayObjectContainer3D;
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.pickup.Ray;
	import snjdck.gpu.IScene;
	import snjdck.gpu.asset.GpuContext;
	
	use namespace ns_g3d;

	final public class Scene3D implements IScene
	{
		public const root:DisplayObjectContainer3D = new DisplayObjectContainer3D();
		
		private const ray:Ray = new Ray();
		
		ns_g3d var _mouseX:Number;
		ns_g3d var _mouseY:Number;
		
		private var _width:int;
		private var _height:int;
		
		private const camera3d:Camera3D = new Camera3D();
		
		public function Scene3D()
		{
			root._scene = this;
			root._root = root;
		}
		
		public function update(timeElapsed:int):void
		{
			root.onUpdate(timeElapsed);
			camera3d.clear();
			root.collectDrawUnit(camera3d);
		}
		
		public function draw(context3d:GpuContext):void
		{
			camera3d.draw(context3d);
		}
		
		public function preDrawDepth(context3d:GpuContext):void{}
		
		public function pickup(stageX:Number, stageY:Number, result:Vector.<Object3D>):void
		{
			camera3d.getSceneRay(stageX, stageY, ray);
			camera3d.pickup(ray, result);
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
			camera3d.setScreenSize(width, height);
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