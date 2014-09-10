package snjdck.gpu
{
	import flash.display.Stage;
	import flash.display.Stage3D;
	import flash.display3D.Context3DProfile;
	import flash.display3D.Context3DRenderMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import snjdck.clock.Clock;
	import snjdck.clock.ITicker;
	import snjdck.g2d.core.IDisplayObject2D;
	import snjdck.g2d.core.IDisplayObjectContainer2D;
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.geom.RayTestInfo;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.IGpuRenderTarget;
	import snjdck.gpu.register.ConstRegister;
	import snjdck.gpu.render.GpuRender;
	
	use namespace ns_g3d;
	
	public class View3D implements IGpuRenderTarget, ITicker
	{
		public var timeScale:Number = 1;
		
		private var hasInit:Boolean;
		
		private var viewPort:ViewPort3D;
		private const render:GpuRender = new GpuRender();
		
		private var _renderMode:String;
		private var _profile:String;
		private var _enableErrorChecking:Boolean;
		
		private var stage2d:Stage;
		private var stage3d:Stage3D;
		private var context3d:GpuContext;
		
		private const _backBufferColor:GpuColor = new GpuColor();
		private var _width:int;
		private var _height:int;
		
		public function View3D(stage:Stage, renderMode:String=null, profile:String=null)
		{
			this._width = stage.stageWidth;
			this._height = stage.stageHeight;
			this.stage2d = stage;
			
			this._renderMode = renderMode || Context3DRenderMode.AUTO;
			this._profile = profile || Context3DProfile.BASELINE;
			
			viewPort = new ViewPort3D(this);
			
			viewPort.scene3d.addEventListener(Event.ADDED_TO_STAGE, forwardEvt);
			viewPort.scene3d.addEventListener(Event.REMOVED_FROM_STAGE, forwardEvt);
			
			init();
		}
		
		public function get scene2d():IDisplayObjectContainer2D
		{
			return viewPort.scene2d;
		}
		
		public function get scene3d():Object3D
		{
			return viewPort.scene3d;
		}
		
		private function forwardEvt(evt:Event):void
		{
			stage2d.dispatchEvent(evt);
		}
		
		private function init():void
		{
			stage3d = stage2d.stage3Ds[0];
			stage3d.addEventListener(Event.CONTEXT3D_CREATE, __onDeviceCreate);
			stage3d.requestContext3D(_renderMode, _profile);
			
			stage2d.addEventListener(MouseEvent.CLICK,			__onStageEvent);
			stage2d.addEventListener(MouseEvent.MOUSE_DOWN,		__onStageEvent);
			stage2d.addEventListener(MouseEvent.MOUSE_UP,		__onStageEvent);
		}
		
		public function get height():int
		{
			return _height;
		}
		
		public function get width():int
		{
			return _width;
		}
		
		public function clear(context3d:GpuContext):void
		{
			context3d.clear(_backBufferColor.red, _backBufferColor.green, _backBufferColor.blue, _backBufferColor.alpha);
		}
		
		public function setRenderToSelf(context3d:GpuContext):void
		{
			context3d.setRenderToBackBuffer();
		}
		
		public function get antiAlias():int
		{
			return 4;
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
			context3d.enableErrorChecking = _enableErrorChecking;
			trace(context3d.driverInfo);
			
			Clock.getInstance().add(this);
		}
		
		protected function onDeviceLost():void
		{
			context3d.configureBackBuffer(_width, _height, antiAlias);
			ConstRegister.InitReserved(stage3d.context3D);
		}
		
		public function getObjectUnderPoint(px:Number, py:Number):IDisplayObject2D
		{
			return viewPort.scene2d.pickup(px, py);
		}
		
		private function __onStageEvent(evt:Event):void
		{
			if(viewPort.scene3d.hasMouseEvent(evt.type)){
				var info:RayTestInfo = viewPort.pickNearestObjectUnderPoint(stage2d.mouseX, stage2d.mouseY);
				if(info){
					info.target.notifyMouseEvent(evt.type, info);
				}
			}
		}
		
		public function onTick(timeElapsed:int):void
		{
			viewPort.update(timeElapsed * timeScale);
			
			context3d.setRenderToBackBuffer();
			context3d.clear(_backBufferColor.red, _backBufferColor.green, _backBufferColor.blue, _backBufferColor.alpha);
			viewPort.drawTo(context3d, render);
			context3d.present();
		}
		
		public function set visible(value:Boolean):void
		{
			stage3d.visible = value;
		}
		
		public function set x(value:Number):void
		{
			stage3d.x = value;
		}
		
		public function set y(value:Number):void
		{
			stage3d.y = value;
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