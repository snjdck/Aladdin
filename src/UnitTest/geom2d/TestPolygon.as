package geom2d
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import snjdck.g2d.geom.Polygon;
	
	public class TestPolygon extends Sprite
	{
		private var p:Polygon = new Polygon();
		private var sp:Shape = new Shape();
		
		public function TestPolygon()
		{
			p.addVertex(100, 100);
			p.addVertex(200, 50);
			p.addVertex(400, 300);
			p.addVertex(150, 270);
			p.addVertex(240, 250);
			p.addVertex(290, 200);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, __onMouseMove);
			
			addChild(sp);
			
			var indices:Vector.<uint> = p.triangulate();
			graphics.lineStyle(1, 0xFF);
			p.drawIndices(graphics, indices);
		}
		
		private function __onMouseMove(evt:MouseEvent):void
		{
			var color:uint = p.contains(evt.stageX, evt.stageY) ? 0xFF00 : 0xFF0000;
			
			sp.graphics.clear();
			sp.graphics.lineStyle(1, color);
			p.drawGraphics(sp.graphics);
		}
	}
}