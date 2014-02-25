package geom2d
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	
	public class JudgeTest extends Sprite
	{
		private var pts:Array = [];
		private var isDraging:Boolean;
		
		public function JudgeTest()
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE, __onMouseMove);
			addPt(50, 50);
			addPt(56, 100);
			addPt(100, 80);
			addPt(200, 200);
			onUpdate();
		}
		
		private function addPt(px:Number, py:Number):void
		{
			var pt:DragPt = new DragPt();
			pt.x = px;
			pt.y = py;
			addChild(pt);
			
			pt.addEventListener(MouseEvent.MOUSE_DOWN, __onMouseDown);
			pt.addEventListener(MouseEvent.MOUSE_UP, __onMouseUp);
			
			pts.push(pt);
		}
		
		private function __onMouseDown(evt:MouseEvent):void
		{
			var pt:Sprite = evt.currentTarget as Sprite;
			isDraging = true;
			pt.startDrag();
		}
		
		private function __onMouseMove(evt:MouseEvent):void
		{
			if(isDraging){
				onUpdate();
			}
		}
		
		private function __onMouseUp(evt:MouseEvent):void
		{
			var pt:Sprite = evt.currentTarget as Sprite;
			pt.stopDrag();
			isDraging = false;
		}
		
		private function onUpdate():void
		{
			var g:Graphics = graphics;
			g.clear();
			
			g.lineStyle(2, 0xFF);
			
			g.moveTo(pts[0].x, pts[0].y);
			g.lineTo(pts[1].x, pts[1].y);
			g.lineTo(pts[2].x, pts[2].y);
			g.lineTo(pts[0].x, pts[0].y);
			
//			var ret:int = JudgePtToCircle.Judge(
//				new Point(pts[0].x, pts[0].y),
//				new Point(pts[1].x, pts[1].y),
//				new Point(pts[2].x, pts[2].y),
//				new Point(pts[3].x, pts[3].y)
//			);
			var ret:int = JudgePtInScanArea.Judge(
				new Point(pts[0].x, pts[0].y),
				new Point(pts[1].x, pts[1].y),
				new Point(pts[2].x, pts[2].y),
				new Point(pts[3].x, pts[3].y)
			);
//			
//			var ret:int = JudgePtToTriangle.Judge(
//				new Point(pts[3].x, pts[3].y),
//				new Point(pts[0].x, pts[0].y),
//				new Point(pts[1].x, pts[1].y),
//				new Point(pts[2].x, pts[2].y)
//			);
			
			var color:uint = 0;
			switch(ret){
				case 1:
					color = 0xFF0000;
					break;
				case 0:
					color = 0xFF00;
					break;
				case -1:
					color = 0xFF;
					break;
			}
			pts[3].filters = [new GlowFilter(color)];
		}
	}
}


import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.MouseEvent;

class DragPt extends Sprite
{
	public function DragPt()
	{
		draw();
	}
	
	private function draw():void
	{
		var g:Graphics = graphics;
		
		g.beginFill(0xFF00);
		g.drawCircle(0, 0, 10);
		g.endFill()
	}

}