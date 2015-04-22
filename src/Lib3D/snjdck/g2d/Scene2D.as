package snjdck.g2d
{
	import flash.display3D.Context3DCompareMode;
	import flash.events.MouseEvent;
	
	import snjdck.g2d.impl.DisplayObject2D;
	import snjdck.g2d.impl.DisplayObjectContainer2D;
	import snjdck.g2d.render.Render2D;
	import snjdck.gpu.IScene;
	import snjdck.gpu.asset.AssetMgr;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.support.QuadRender;
	import snjdck.shader.ShaderName;
	
	public class Scene2D implements IScene
	{
		public const root:DisplayObjectContainer2D = new DisplayObjectContainer2D();
		
		private const render:Render2D = new Render2D();
		
		public function Scene2D(){}
		
		public function update(timeElapsed:int):void
		{
			root.onUpdate(timeElapsed);
		}
		
		public function draw(context3d:GpuContext):void
		{
			render.drawBegin(context3d);
			render.pushScreen(context3d.bufferWidth, context3d.bufferHeight);
			root.draw(render, context3d);
			render.popScreen();
		}
		
		public function preDrawDepth(context3d:GpuContext):void
		{
			context3d.program = AssetMgr.Instance.getProgram(ShaderName.G2D_PRE_DRAW_DEPTH);
			
			context3d.setDepthTest(true, Context3DCompareMode.LESS);
			QuadRender.Instance.drawBegin(context3d);
			
			context3d.setColorMask(false, false, false, false);
			
			render.pushScreen(context3d.bufferWidth, context3d.bufferHeight);
			root.preDrawDepth(render, context3d);
			render.popScreen();
			
			context3d.setColorMask(true, true, true, true);
		}
		
		public function addChild(child:DisplayObject2D):void
		{
			root.addChild(child);
		}
		
		public function notifyEvent(evtType:String, stageX:Number, stageY:Number):Boolean
		{
			var result:Boolean = true;
			var target:DisplayObject2D = root.pickup(stageX, stageY);
			
			if(null == target){
				target = root;
				result = false;
			}
			while(target != null && target.mouseEnabled){
				switch(evtType){
					case MouseEvent.MOUSE_DOWN:
						target.mouseDownSignal.notify();
						break;
					case MouseEvent.MOUSE_UP:
						target.mouseUpSignal.notify();
						break;
				}
				target = target.parent;
			}
			return result;
		}
	}
}