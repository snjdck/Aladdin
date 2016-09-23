package snjdck.g3d
{
	import flash.events.MouseEvent;
	
	import snjdck.g3d.core.Camera3D;
	import snjdck.g3d.core.DisplayObjectContainer3D;
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.pickup.Ray;
	import snjdck.g3d.render.DrawUnitCollector3D;
	import snjdck.gpu.IScene;
	import snjdck.gpu.asset.GpuContext;
	
	use namespace ns_g3d;

	final public class Scene3D implements IScene
	{
		public const root:DisplayObjectContainer3D = new DisplayObjectContainer3D();
		public const camera:Camera3D = new Camera3D();
		
		private const collector:DrawUnitCollector3D = new DrawUnitCollector3D();
		
		private const ray:Ray = new Ray();
		
		ns_g3d var _mouseX:Number;
		ns_g3d var _mouseY:Number;
		
		private var _width:int;
		private var _height:int;
		
		public function Scene3D()
		{
			root._scene = this;
			root._root = root;
		}
		
		public function update(timeElapsed:int):void
		{
			camera.update();
			collector.clear();
			root.collectDrawUnit(collector);
			collector.update(timeElapsed);
		}
		
		public function needDraw():Boolean
		{
			return collector.hasDrawUnits();
		}
		
		public function draw(context3d:GpuContext):void
		{
			camera.upload(context3d);
			collector.renderDrawUnits(context3d);
		}
		
		public function preDrawDepth(context3d:GpuContext):void{}
		
		public function pickup(stageX:Number, stageY:Number, result:Vector.<Object3D>):void
		{
			camera.getSceneRay(stageX, stageY, ray);
			collector.hitTest(ray, result);
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
			camera.setScreenSize(_width, _height);
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