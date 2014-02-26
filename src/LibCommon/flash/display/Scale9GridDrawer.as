package flash.display
{
	import flash.geom.Rectangle;
	
	import geom3d.createMeshIndices;

	final public class Scale9GridDrawer
	{
		static public function Draw(g:Graphics, bmd:BitmapData, x:Number, y:Number, width:Number, height:Number, scale9Grid:Rectangle, sourceRect:Rectangle=null):void
		{
			sourceRect ||= bmd.rect;
			g.beginBitmapFill(bmd);
			g.drawTriangles(
				CreateVertices(sourceRect, x, y, width, height, scale9Grid),
				Indices,
				CreateUVT(bmd, scale9Grid, sourceRect)
			);
			g.endFill();
		}
		
		static private function CreateVertices(sourceRect:Rectangle, x:Number, y:Number, width:Number, height:Number, scale9Grid:Rectangle):Vector.<Number>
		{
			const x1:Number = x + scale9Grid.x;
			const x3:Number = x + width;
			const x2:Number = x3 - (sourceRect.width - scale9Grid.right);
			
			const y1:Number = y + scale9Grid.y;
			const y3:Number = y + height;
			const y2:Number = y3 - (sourceRect.height - scale9Grid.bottom);
			
			return new <Number>[
				x, y,  x1, y,  x2, y,  x3, y,
				x, y1, x1, y1, x2, y1, x3, y1,
				x, y2, x1, y2, x2, y2, x3, y2,
				x, y3, x1, y3, x2, y3, x3, y3
			];
		}
		
		static private function CreateUVT(bmd:BitmapData, scale9Grid:Rectangle, sourceRect:Rectangle):Vector.<Number>
		{
			const u1:Number = (sourceRect.x + scale9Grid.x)		/ bmd.width;
			const u2:Number = (sourceRect.x + scale9Grid.right)	/ bmd.width;
			
			const v1:Number = (sourceRect.y + scale9Grid.y)		/ bmd.height;
			const v2:Number = (sourceRect.y + scale9Grid.bottom)/ bmd.height;
			
			return new <Number>[
				0, 0,  u1, 0,  u2, 0,  1, 0,
				0, v1, u1, v1, u2, v1, 1, v1,
				0, v2, u1, v2, u2, v2, 1, v2,
				0, 1,  u1, 1,  u2, 1,  1, 1
			];
		}
		
		static private const Indices:Vector.<int> = new Vector.<int>();
		createMeshIndices(4, 4, Indices);
	}
}