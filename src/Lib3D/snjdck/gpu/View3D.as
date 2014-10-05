package snjdck.gpu
{
	import flash.display.Stage;
	import flash.display.Stage3D;
	import flash.events.Event;
	
	import snjdck.clock.Clock;
	import snjdck.clock.ITicker;
	import snjdck.g2d.impl.DisplayObjectContainer2D;
	import snjdck.g2d.render.Render2D;
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.core.Camera3D;
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.render.Render3D;
	import snjdck.gpu.asset.GpuContext;
	
	use namespace ns_g3d;
	
	public class View3D implements ITicker
	{
		public const scene3d:Object3D = new Object3D();
		public const scene2d:DisplayObjectContainer2D = new DisplayObjectContainer2D();
		
		public var camera3d:Camera3D;
		
		public var timeScale:Number = 1;
		
		private var hasInit:Boolean;
		
		public const render3d:Render3D = new Render3D();
		private const render2d:Render2D = new Render2D();
		
		private var _enableErrorChecking:Boolean;
		
		internal var stage2d:Stage;
		internal var stage3d:Stage3D;
		
		private var context3d:GpuContext;
		
		private const _backBufferColor:GpuColor = new GpuColor(0xFF000000);
		private var _width:int;
		private var _height:int;
		
		public function View3D(stage:Stage)
		{
			this._width = stage.stageWidth;
			this._height = stage.stageHeight;
			this.stage2d = stage;
			
			camera3d = Camera3D.NewPerspectiveCamera(60, _width/_height, 500, 4000);
			camera3d.zOffset = -1000;
			/*
			camera3d.viewport.width = 0.5;
			camera3d.viewport.height = 0.5;
			
			var testCamera:Camera3D = Camera3D.NewIsoCamera(_width, _height, -1000, 4000);
			testCamera.depth = 1;
			scene3d.addChild(testCamera);
			testCamera.viewport.x = 0.5;
			testCamera.viewport.width = 0.5;
			testCamera.viewport.height = 0.5;
			*/
			
			init();
		}
		
		public function get screenX():Number
		{
			return 2 * (stage2d.mouseX - stage3d.x) / _width - 1;
		}
		
		public function get screenY():Number
		{
			return 1 - 2 * (stage2d.mouseY - stage3d.y) / _height;
		}
		
		private function init():void
		{
			stage3d = stage2d.stage3Ds[0];
			stage3d.addEventListener(Event.CONTEXT3D_CREATE, __onDeviceCreate);
			stage3d.requestContext3D();
		}
		
		public function get height():int
		{
			return _height;
		}
		
		public function get width():int
		{
			return _width;
		}
		
		public function set backgroundColor(color:uint):void
		{
			_backBufferColor.value = color;
		}
		
		private function __onDeviceCreate(evt:Event):void
		{
			context3d = new GpuContext(stage3d.context3D);
			if(!hasInit){
				onDeviceInit();
				hasInit = true;
			}
			onDeviceLost();
		}
		
		private function onDeviceInit():void
		{
			trace(context3d.driverInfo);
			context3d.enableErrorChecking = _enableErrorChecking;
			Clock.getInstance().add(this);
		}
		
		protected function onDeviceLost():void
		{
			context3d.configureBackBuffer(_width, _height, 4);
			context3d.setFc(27, new <Number>[0.004, 0, 0, 0.6]);
		}
		
		public function onTick(timeElapsed:int):void
		{
			scene3d.onUpdate(timeElapsed * timeScale);
			scene2d.onUpdate(timeElapsed);
			
			context3d.clear(_backBufferColor.red, _backBufferColor.green, _backBufferColor.blue, _backBufferColor.alpha);
			render3d.draw(scene3d, context3d);
			render2d.drawScene(scene2d, context3d);
			context3d.present();
		}
		
		public function set enableErrorChecking(value:Boolean):void
		{
			if(context3d != null){
				context3d.enableErrorChecking = value;
			}
			_enableErrorChecking = value;
		}
	}
}