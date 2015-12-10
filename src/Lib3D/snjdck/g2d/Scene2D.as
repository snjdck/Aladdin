package snjdck.g2d
{
	import flash.events.MouseEvent;
	
	import snjdck.g2d.impl.DisplayObject2D;
	import snjdck.g2d.impl.DisplayObjectContainer2D;
	import snjdck.g2d.impl.OpaqueAreaCollector;
	import snjdck.g2d.render.Render2D;
	import snjdck.g2d.viewport.IViewPort;
	import snjdck.g2d.viewport.IViewPortLayer;
	import snjdck.gpu.IScene;
	import snjdck.gpu.asset.AssetMgr;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.shader.ShaderName;
	
	use namespace ns_g2d;
	
	final public class Scene2D implements IScene, IViewPort
	{
		public const root:DisplayObjectContainer2D = new DisplayObjectContainer2D();
		private const viewPort:IViewPort = new ViewPort2D(root);
		
		private const collector:OpaqueAreaCollector = new OpaqueAreaCollector();
		private const render2d:Render2D = new Render2D();
		
		ns_g2d var _mouseX:Number;
		ns_g2d var _mouseY:Number;
		
		private var _width:int;
		private var _height:int;
		
		public function Scene2D()
		{
			root._scene = this;
			root._root = root;
		}
		
		public function update(timeElapsed:int):void
		{
			root.updateMouseXY(_mouseX, _mouseY);
			root.onUpdate(timeElapsed);
			collector.clear();
			root.collectOpaqueArea(collector);
			onMouseMove();
		}
		
		public function needDraw():Boolean
		{
			return true;
		}
		
		public function draw(context3d:GpuContext):void
		{
			render2d.drawBegin(context3d);
			render2d.pushScreen(context3d.bufferWidth, context3d.bufferHeight);
			root.draw(render2d, context3d);
			render2d.popScreen();
		}
		
		public function needPreDrawDepth():Boolean
		{
			return collector.hasOpaqueArea();
		}
		
		public function preDrawDepth(context3d:GpuContext):void
		{
			context3d.program = AssetMgr.Instance.getProgram(ShaderName.G2D_PRE_DRAW_DEPTH);
			
			render2d.pushScreen(context3d.bufferWidth, context3d.bufferHeight);
			collector.preDrawDepth(render2d, context3d);
			render2d.popScreen();
		}
		
		private var prevMouseTarget:DisplayObject2D;
		
		private function onMouseMove():void
		{
			var mouseTarget:DisplayObject2D = root.findTargetUnderMouse() || root;
			
			if(mouseTarget == prevMouseTarget){
				return;
			}
			
			var shareParent:DisplayObject2D = findShareParent(mouseTarget, prevMouseTarget);
			
			notifyEventImpl(prevMouseTarget, MouseEvent.MOUSE_OUT, shareParent);
			notifyEventImpl(mouseTarget, MouseEvent.MOUSE_OVER, shareParent);
			
			prevMouseTarget = mouseTarget;
		}
		
		public function notifyEvent(evtType:String):Boolean
		{
			notifyEventImpl(prevMouseTarget, evtType);
			return prevMouseTarget != root;
		}
		
		private function notifyEventImpl(target:DisplayObject2D, evtType:String, finalNode:DisplayObject2D=null):void
		{
			while(target != finalNode){
				if(target.mouseEnabled){
					target.notify(evtType, target);
				}
				target = target.parent;
			}
		}
		
		public function get mouseX():Number
		{
			return _mouseX;
		}
		
		public function get mouseY():Number
		{
			return _mouseY;
		}
		
		private function findShareParent(a:DisplayObject2D, b:DisplayObject2D):DisplayObject2D
		{
			while(a != null){
				var tb:DisplayObject2D = b;
				while(tb != null){
					if(a == tb){
						return a;
					}
					tb = tb.parent;
				}
				a = a.parent;
			}
			return null;
		}
		
		public function createLayer(name:String, parentName:String=null):void
		{
			viewPort.createLayer(name, parentName);
		}
		
		public function getLayer(name:String):IViewPortLayer
		{
			return viewPort.getLayer(name);
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