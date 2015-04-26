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
	import snjdck.g3d.Scene3D;
	import snjdck.g2d.ns_g2d;
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.support.Camera3DFactory;
	import snjdck.gpu.asset.GpuContext;
	
	use namespace ns_g2d;
	use namespace ns_g3d;
	
	final public class View3D implements ITicker
	{
		public const scene3d:Scene3D = new Scene3D();
		public const scene2d:Scene2D = new Scene2D();
		
		public var timeScale:Number = 1;
		public var enableErrorChecking:Boolean;
		
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
			
			scene3d.camera = Camera3DFactory.NewIsoCamera(_width, _height, 0, 5000);
//			camera3d = Camera3DFactory.NewPerspectiveCamera(60, _width/_height, 500, 4000);
			scene3d.camera.zOffset = -1000;
			
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
			stage2d.addEventListener(MouseEvent.MOUSE_MOVE, __onMouseMove);
			stage2d.addEventListener(MouseEvent.MOUSE_DOWN,	__onStageEvent);
			stage2d.addEventListener(MouseEvent.MOUSE_UP,	__onStageEvent);
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
			if(isMousePositionChanged){
				scene3d._mouseX = scene2d._mouseX = stage2d.mouseX;
				scene3d._mouseY = scene2d._mouseY = stage2d.mouseY;
				isMousePositionChanged = false;
			}
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
		
		public function notifyEvent(evtType:String):void
		{
			var stageX:Number = stage2d.mouseX - stage3d.x;
			var stageY:Number = stage2d.mouseY - stage3d.y;
			
			if(scene2d.notifyEvent(evtType, stageX, stageY)){
				return;
			}
			
			var screenX:Number = 2 * stageX / _width - 1;
			var screenY:Number = 1 - 2 * stageY / _height;
			
			scene3d.notifyEvent(evtType, screenX, screenY);
		}
		
		private function __onStageEvent(evt:MouseEvent):void
		{
			notifyEvent(evt.type);
		}
		
		private var isMousePositionChanged:Boolean;
		
		private function __onMouseMove(evt:MouseEvent):void
		{
			isMousePositionChanged = true;
		}
	}
}