package snjdck.g3d.core
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display3D.Context3DRenderMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.Capabilities;
	import flash.utils.getTimer;
	
	import snjdck.g2d.core.IDisplayObject2D;
	import snjdck.g2d.core.IDisplayObjectContainer2D;
	import snjdck.g3d.asset.IGpuContext;
	import snjdck.g3d.asset.impl.GpuAssetFactory;
	import snjdck.g3d.asset.impl.GpuFrameBuffer;
	import snjdck.g3d.geom.RayTestInfo;
	import snjdck.g3d.ns_g3d;
	
	use namespace ns_g3d;
	
	public class View3D extends Sprite
	{
		private var hasInit:Boolean;
		
		private var frameBuffer:GpuFrameBuffer;
		private var viewPort:ViewPort3D;
		
		private var timeScale:Number;
		private var context3DRenderMode:String;
		
		private var stage3d:Stage3D;
		private var context3d:IGpuContext;
		
		public function View3D(backBufferWidth:int, backBufferHeight:int, timeScale:Number=1, context3DRenderMode:String=null)
		{
			this.timeScale = timeScale;
			this.context3DRenderMode = context3DRenderMode || Context3DRenderMode.AUTO;
			
			frameBuffer = new GpuFrameBuffer(backBufferWidth, backBufferHeight);
			viewPort = new ViewPort3D(frameBuffer);
			
			addEventListener(Event.ADDED_TO_STAGE,		__onAddedToStage);
			
			viewPort.scene3d.addEventListener(Event.ADDED_TO_STAGE, forwardEvt);
			viewPort.scene3d.addEventListener(Event.REMOVED_FROM_STAGE, forwardEvt);
		}
		
		public function get scene2d():IDisplayObjectContainer2D
		{
			return viewPort.scene2d;
		}
		
		public function get scene3d():Object3D
		{
			return viewPort.scene3d;
		}
		
		public function getContext():IGpuContext
		{
			return context3d;
		}
		
		private function forwardEvt(evt:Event):void
		{
			dispatchEvent(evt);
		}
		
		private function __onAddedToStage(evt:Event):void
		{
			if(evt.target != this){
				return;
			}
			
			stage3d = stage.stage3Ds[0];
			stage3d.addEventListener(Event.CONTEXT3D_CREATE, __onDeviceCreate);
			stage3d.requestContext3D(context3DRenderMode);
			
			stage3d.visible = visible;
			stage3d.x = x;
			stage3d.y = y;
			
			drawSelf();
			
			addEventListener(MouseEvent.CLICK,			__onStageEvent);
			addEventListener(MouseEvent.MOUSE_DOWN,		__onStageEvent);
			addEventListener(MouseEvent.MOUSE_UP,		__onStageEvent);
		}
		
		private function drawSelf():void
		{
			var g:Graphics = graphics;
			g.clear();
			g.beginFill(0xFF0000, 0);
			g.drawRect(0, 0, frameBuffer.width, frameBuffer.height);
			g.endFill();
		}
		
		public function set backgroundColor(color:uint):void
		{
			frameBuffer.backgroundColor = color;
		}
		
		private function __onDeviceCreate(evt:Event):void
		{
			context3d = GpuAssetFactory.CreateGpuContext(stage3d.context3D);
			if(!hasInit){
				onDeviceInit();
				hasInit = true;
			}
			onDeviceLost();
		}
		
		private function onDeviceInit():void
		{
			context3d.enableErrorChecking = Capabilities.isDebugger;
			trace(context3d.driverInfo);
			
			addEventListener(Event.ENTER_FRAME,	__onEnterFrame);
			timestamp = getTimer();
		}
		
		protected function onDeviceLost():void
		{
			var fcData:Vector.<Number> = new Vector.<Number>();
			
			fcData.push(0.004, 0, 0, 0.6);//0.6 是阴影的alpha值
			
			var regCount:int = Math.ceil(fcData.length / 4);
			context3d.setFc(0, fcData, regCount);
		}
		
		private function update(timeElapsed:int):void
		{
			timeElapsed *= timeScale;
			
			viewPort.update(timeElapsed);
			viewPort.draw(context3d);
			context3d.present();
		}
		
		public function getObjectUnderPoint(px:Number, py:Number):IDisplayObject2D
		{
			return viewPort.getObjectUnderPoint(px, py);
		}
		
		private function __onStageEvent(evt:Event):void
		{
			if(viewPort.scene3d.hasMouseEvent(evt.type)){
				var info:RayTestInfo = viewPort.pickNearestObjectUnderPoint(mouseX, mouseY);
				if(info){
					info.target.notifyMouseEvent(evt.type, info);
				}
			}
		}
		
		private var timestamp:int;
		
		private function __onEnterFrame(evt:Event):void
		{
			var now:int = getTimer();
			var timeElapsed:int = now - timestamp;
			timestamp = now;
			
			update(timeElapsed);
		}
		
		override public function set visible(value:Boolean):void
		{
			super.visible = value;
			if(stage3d){
				stage3d.visible = value;
			}
		}
		
		override public function set x(value:Number):void
		{
			super.x = value;
			if(stage3d){
				stage3d.x = value;
			}
		}
		
		override public function set y(value:Number):void
		{
			super.y = value;
			if(stage3d){
				stage3d.y = value;
			}
		}
	}
}