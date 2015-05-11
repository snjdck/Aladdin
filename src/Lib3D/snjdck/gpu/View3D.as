package snjdck.gpu
{
	import flash.display.Stage;
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DCompareMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import snjdck.clock.Clock;
	import snjdck.clock.ITicker;
	import snjdck.g2d.Scene2D;
	import snjdck.g2d.ns_g2d;
	import snjdck.g3d.Scene3D;
	import snjdck.g3d.ns_g3d;
	import snjdck.gpu.asset.GpuContext;
	
	use namespace ns_g2d;
	use namespace ns_g3d;
	
	final public class View3D implements ITicker
	{
		public const scene3d:Scene3D = new Scene3D();
		public const scene2d:Scene2D = new Scene2D();
		
		public var timeScale:Number = 1;
		public var enableErrorChecking:Boolean;
		
		private var stage2d:Stage;
		private var stage3d:Stage3D;
		
		private var context3d:GpuContext;
		
		private const _backBufferColor:GpuColor = new GpuColor(0xFF000000);
		private var _width:int;
		private var _height:int;
		
		public function View3D(stage:Stage)
		{
			this._width = stage.stageWidth;
			this._height = stage.stageHeight;
			this.stage2d = stage;
			
			scene3d.camera.enableViewFrusum = true;
			scene3d.camera.ortho = true;
			scene3d.camera.setScreenSize(_width, _height);
			
			init();
		}
		
		private function init():void
		{
			stage2d.addEventListener(MouseEvent.MOUSE_DOWN,	__onStageEvent);
			stage2d.addEventListener(MouseEvent.MOUSE_UP,	__onStageEvent);
//			stage2d.addEventListener(Event.RESIZE, __onResize);
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
			var ctx:Context3D = stage3d.context3D;
			ctx.enableErrorChecking = enableErrorChecking;
			trace(ctx.driverInfo);
			context3d = new GpuContext(ctx);
			onDeviceLost();
			Clock.getInstance().add(this);
		}
		
		protected function onDeviceLost():void
		{
			context3d.configureBackBuffer(_width, _height, 4);
			context3d.setFc(27, new <Number>[0.004, 0, 0, 0.6]);
		}
		
		public function onTick(timeElapsed:int):void
		{
			updateMouseXY();
			scene3d.update(timeElapsed * timeScale);
			scene2d.update(timeElapsed);
			context3d.clear(_backBufferColor.red, _backBufferColor.green, _backBufferColor.blue, _backBufferColor.alpha);
			context3d.setDepthTest(true, Context3DCompareMode.LESS);
			context3d.setColorMask(false, false, false, false);
			scene2d.preDrawDepth(context3d);
			scene3d.preDrawDepth(context3d);
			context3d.setColorMask(true, true, true, true);
			scene3d.draw(context3d);
			scene2d.draw(context3d);
			context3d.present();
		}
		
		private function updateMouseXY():void
		{
			var px:Number = stage2d.mouseX - stage3d.x;
			var py:Number = stage2d.mouseY - stage3d.y;
			scene2d._mouseX = px;
			scene2d._mouseY = py;
			scene3d._mouseX = px - 0.5 * _width;
			scene3d._mouseY = 0.5 * _height - py;
		}
		
		private function __onStageEvent(evt:MouseEvent):void
		{
			if(!scene2d.notifyEvent(evt.type)){
				scene3d.notifyEvent(evt.type);
			}
		}
		
		private function __onResize(evt:Event):void
		{
			this._width = stage2d.stageWidth;
			this._height = stage2d.stageHeight;
			
			scene3d.camera.setScreenSize(_width, _height);
			onDeviceLost();
		}
	}
}