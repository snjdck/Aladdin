package snjdck.gpu
{
	import flash.display.Stage;
	import flash.display3D.Context3DCompareMode;
	import flash.events.MouseEvent;
	
	import snjdck.g3d.Scene3D;
	import snjdck.g3d.ns_g3d;
	
	use namespace ns_g3d;
	
	final public class View3D extends View2D
	{
		public const scene3d:Scene3D = new Scene3D();
		
		public function View3D(stage:Stage)
		{
			super(stage);
		}
		
		override protected function updateMouseXY(px:Number, py:Number):void
		{
			super.updateMouseXY(px, py);
			scene3d._mouseX = px - 0.5 * _width;
			scene3d._mouseY = 0.5 * _height - py;
		}
		
		override protected function updateScene(timeElapsed:int):void
		{
			super.updateScene(timeElapsed);
			scene3d.update(timeElapsed * timeScale);
		}
		
		override protected function drawScene():void
		{
			if(scene3d.needDraw()){
				if(scene2d.needPreDrawDepth()){
					context3d.setDepthTest(true, Context3DCompareMode.LESS);
					context3d.setColorMask(false, false, false, false);
					scene2d.preDrawDepth(context3d);
					context3d.setColorMask(true, true, true, true);
				}
				scene3d.draw(context3d);
			}
			super.drawScene();
			context3d.gc();
		}
		
		override public function resize(width:int, height:int):void
		{
			super.resize(width, height);
			scene3d.resize(width, height);
		}
		
		override protected function __onStageEvent(evt:MouseEvent):void
		{
			if(!scene2d.notifyEvent(evt.type)){
				scene3d.notifyEvent(evt.type);
			}
		}
	}
}