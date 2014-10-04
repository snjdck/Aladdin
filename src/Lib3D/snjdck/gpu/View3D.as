package snjdck.gpu
{
	import flash.display.Stage;
	import flash.display.Stage3D;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	
	import snjdck.clock.Clock;
	import snjdck.clock.ITicker;
	import snjdck.g2d.impl.DisplayObject2D;
	import snjdck.g2d.impl.DisplayObjectContainer2D;
	import snjdck.g2d.render.Render2D;
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.core.Camera3D;
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.pickup.RayTestInfo;
	import snjdck.g3d.render.Render3D;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.g3d.projection.OrthoProjection3D;
	import snjdck.g3d.projection.PerspectiveProjection3D;
	
	use namespace ns_g3d;
	
	public class View3D implements ITicker
	{
		public const scene3d:Object3D = new Object3D();
		public const scene2d:DisplayObjectContainer2D = new DisplayObjectContainer2D();
		
		public const camera3d:Camera3D = new Camera3D();
//		private const rayCastStack:RayCastStack = new RayCastStack();
		
		public var timeScale:Number = 1;
		
		private var hasInit:Boolean;
		
		private const render3d:Render3D = new Render3D();
		private const render2d:Render2D = new Render2D();
		
		private var _enableErrorChecking:Boolean;
		
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
			
			scene3d.addEventListener(Event.ADDED_TO_STAGE, forwardEvt);
			scene3d.addEventListener(Event.REMOVED_FROM_STAGE, forwardEvt);
//			var proj:PerspectiveProjection3D = new PerspectiveProjection3D();
//			proj.fov(60, _width/_height);
//			proj.setDepthCliping(1, 200);
			var proj:OrthoProjection3D = new OrthoProjection3D();
			proj.resize(_width, _height);
			camera3d.projection = proj;
			
//			var testCamera:Camera3D = new Camera3D();
//			testCamera.projection = new OrthoProjection3D();
//			testCamera.projection.resize(_width, _height);
//			testCamera.depth = 1;
//			scene3d.addChild(testCamera);
//			testCamera.viewportRect.x = 0.5;
//			testCamera.viewportRect.width = 0.5;
			
			
			init();
		}
		
		private function forwardEvt(evt:Event):void
		{
			stage2d.dispatchEvent(evt);
		}
		
		private function init():void
		{
			stage3d = stage2d.stage3Ds[0];
			stage3d.addEventListener(Event.CONTEXT3D_CREATE, __onDeviceCreate);
			stage3d.requestContext3D();
			
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
		
		public function getObjectUnderPoint(px:Number, py:Number):DisplayObject2D
		{
			return scene2d.pickup(px, py);
		}
		
		private function __onStageEvent(evt:Event):void
		{
			if(scene3d.hasMouseEvent(evt.type)){
				var info:RayTestInfo = pickNearestObjectUnderPoint(stage2d.mouseX, stage2d.mouseY);
				if(info){
					info.target.notifyMouseEvent(evt.type, info);
				}
			}
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
		
		public function pickObjectsUnderPoint(mouseX:Number, mouseY:Number, result:Vector.<RayTestInfo>):void
		{
			var screenX:Number = 2 * (mouseX - stage3d.x) / _width - 1;
			var screenY:Number = 1 - 2 * (mouseY - stage3d.y) / _height;
			render3d.pickup(screenX, screenY, result);
		}
		
		public function pickNearestObjectUnderPoint(mouseX:Number, mouseY:Number):RayTestInfo
		{
			var result:Vector.<RayTestInfo> = new Vector.<RayTestInfo>();
			
			pickObjectsUnderPoint(mouseX, mouseY, result);
			
			if(result.length < 1){
				return null;
			}
			
			result.sort(__sort);
			return result[0];
		}
		
		static private function __sort(a:RayTestInfo, b:RayTestInfo):int
		{
			var pa:Vector3D = a.globalPos;
			var pb:Vector3D = b.globalPos;
			return pa.z < pb.z ? -1 : 1;
		}
	}
}