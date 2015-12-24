package snjdck.gpu
{
	import flash.display.Stage;
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProfile;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import snjdck.clock.Clock;
	import snjdck.clock.ITicker;
	import snjdck.g2d.Scene2D;
	import snjdck.g2d.ns_g2d;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuContextEx;
	
	use namespace ns_g2d;
	
	public class View2D implements ITicker
	{
		public const scene2d:Scene2D = new Scene2D();
		
		public var timeScale:Number = 1;
		public var enableErrorChecking:Boolean;
		
		private var stage2d:Stage;
		private var stage3d:Stage3D;
		
		protected var context3d:GpuContext;
		
		private const _backBufferColor:GpuColor = new GpuColor(0xFF000000);
		protected var _width:int;
		protected var _height:int;
		
		public function View2D(stage:Stage)
		{
			this.stage2d = stage;
			resize(stage2d.stageWidth, stage2d.stageHeight);
			init();
		}
		
		private function init():void
		{
			var eventList:Array = [
				MouseEvent.RIGHT_CLICK,
				MouseEvent.RIGHT_MOUSE_DOWN,
				MouseEvent.RIGHT_MOUSE_UP,
				MouseEvent.CLICK,
				MouseEvent.MOUSE_DOWN,
				MouseEvent.MOUSE_UP
			];
			for each(var evtName:String in eventList){
				stage2d.addEventListener(evtName, __onStageEvent);
			}
//			stage2d.addEventListener(Event.RESIZE, __onResize);
			stage3d = stage2d.stage3Ds[0];
			stage3d.addEventListener(Event.CONTEXT3D_CREATE, __onDeviceCreate);
			
			var profileList:Vector.<String> = new Vector.<String>();
			profileList.push(Context3DProfile.STANDARD_CONSTRAINED);
			profileList.push(Context3DProfile.BASELINE);
			stage3d.requestContext3DMatchingProfiles(profileList);
		}
		
		public function set backgroundColor(color:uint):void
		{
			_backBufferColor.value = color;
		}
		
		private function __onDeviceCreate(evt:Event):void
		{
			var ctx:Context3D = stage3d.context3D;
			ctx.enableErrorChecking = enableErrorChecking;
			var isFirstTime:Boolean = (null == context3d);
			context3d = new GpuContextEx(ctx);
			onDeviceLost();
			if(isFirstTime){
				GpuInfo.Init(ctx.profile, ctx.driverInfo);
				Clock.getInstance().add(this);
			}
		}
		
		private function onDeviceLost():void
		{
			context3d.configureBackBuffer(_width, _height, 4);
			context3d.setFc(27, new <Number>[0.004, 0, 0, 0.6]);
		}
		
		public function onTick(timeElapsed:int):void
		{
			updateMouseXY(stage2d.mouseX-stage3d.x, stage2d.mouseY-stage3d.y);
			updateScene(timeElapsed);
			context3d.clear(_backBufferColor.red, _backBufferColor.green, _backBufferColor.blue, _backBufferColor.alpha);
			drawScene();
			context3d.present();
		}
		
		protected function updateMouseXY(px:Number, py:Number):void
		{
			scene2d._mouseX = px;
			scene2d._mouseY = py;
		}
		
		protected function updateScene(timeElapsed:int):void
		{
			scene2d.update(timeElapsed);
		}
		
		protected function drawScene():void
		{
			scene2d.draw(context3d);
		}
		
		public function resize(width:int, height:int):void
		{
			_width = width;
			_height = height;
			scene2d.resize(width, height);
		}
		
		protected function __onStageEvent(evt:MouseEvent):void
		{
			scene2d.notifyEvent(evt.type);
		}
		
		private function __onResize(evt:Event):void
		{
			resize(stage2d.stageWidth, stage2d.stageHeight);
			onDeviceLost();
		}
	}
}