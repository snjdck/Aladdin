package snjdck.g2d
{
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
		
		private const render2d:Render2D = new Render2D();
		
		public function Scene2D(){}
		
		public function update(timeElapsed:int):void
		{
			root.onUpdate(timeElapsed);
		}
		
		public function draw(context3d:GpuContext):void
		{
			render2d.drawBegin(context3d);
			render2d.pushScreen(context3d.bufferWidth, context3d.bufferHeight);
			root.draw(render2d, context3d);
			render2d.popScreen();
		}
		
		public function preDrawDepth(context3d:GpuContext):void
		{
			context3d.program = AssetMgr.Instance.getProgram(ShaderName.G2D_PRE_DRAW_DEPTH);
			QuadRender.Instance.drawBegin(context3d);
			
			render2d.pushScreen(context3d.bufferWidth, context3d.bufferHeight);
			root.preDrawDepth(render2d, context3d);
			render2d.popScreen();
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
						target.mouseDownSignal.notify(target);
						break;
					case MouseEvent.MOUSE_UP:
						target.mouseUpSignal.notify(target);
						break;
				}
				target = target.parent;
			}
			return result;
		}
	}
}