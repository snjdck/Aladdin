package snjdck
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import math.combination;
	
	final public class GDI
	{
		static public function moveTo(g:Graphics, pt:Point):void
		{
			g.moveTo(pt.x, pt.y);
		}
		
		static public function lineTo(g:Graphics, pt:Point):void
		{
			g.lineTo(pt.x, pt.y);
		}
		
		static public function curveTo(g:Graphics, control:Point, anchor:Point):void
		{
			g.curveTo(control.x, control.y, anchor.x, anchor.y);
		}
		
		static public function curveBy(g:Graphics, from:Point, cross:Point, to:Point):void
		{
			curveTo(g, new Point(
				cross.x * 2 - 0.5 * (from.x + to.x),
				cross.y * 2 - 0.5 * (from.y + to.y)
			), to);
		}
		
		static public function drawLine(g:Graphics, from:Point, to:Point):void
		{
			moveTo(g, from);
			lineTo(g, to);
		}
		
		static public function drawRect(g:Graphics, rect:Rectangle):void
		{
			g.drawRect(rect.x, rect.y, rect.width, rect.height);
		}
		
		static public function drawBitmap(g:Graphics, bmd:BitmapData, x:Number, y:Number, width:Number, height:Number, offsetX:Number=0, offsetY:Number=0):void
		{
			matrix.tx = x - offsetX;
			matrix.ty = y - offsetY;
			
			g.beginBitmapFill(bmd, matrix);
			g.drawRect(x, y, width, height);
			g.endFill();
		}
		
		/**
		 * @param pointList Array or Vector
		 */
		static public function drawSegmentPath(g:Graphics, pointList:Object):void
		{
			const n:int = pointList.length;
			if (n < 2) return;
			
			moveTo(g, pointList[0]);
			for(var i:int=1; i<n; i++){
				lineTo(g, pointList[i]);
			}
		}
		
		static public function drawCurvePath(g:Graphics, pointList:Array):void
		{	
			if(pointList.length < 3){
				return;
			}
			
			const centerPoints:Array = calcCenterPoints(pointList);
			const n:int = centerPoints.length;
			
			drawLine(g, pointList[0], centerPoints[0]);
			for(var i:int=1; i < n; i++){
				curveTo(g, pointList[i], centerPoints[i]);
			}
			lineTo(g, pointList[n]);
		}
		
		static private function bezier(t:Number, controlPts:Array, result:Point):void
		{
			const n:int = controlPts.length - 1;
			
			var x:Number = 0;
			var y:Number = 0;
			
			for(var i:int=0; i <= n; i++)
			{
				const blend:Number = combination(n, i) * Math.pow(t, i) * Math.pow(1-t, n-i);
				const pt:Point = controlPts[i];
				x += blend * pt.x;
				y += blend * pt.y;
			}
			
			result.x = x;
			result.y = y;
		}
		
		static public function calcBezierPath(pointList:Array, count:int):Array
		{
			if(pointList.length < 3){
				return pointList;
			}
			
			const centerPoints:Array = calcCenterPoints(pointList);
			const n:int = centerPoints.length;
			
			var result:Array = [pointList[0], centerPoints[0]];
			for(var i:int=1; i < n; i++){
				bezierSpline([centerPoints[i-1], pointList[i], centerPoints[i]], count, result);
			}
			result.push(pointList[n]);
			return result;
		}
		
		static private function bezierSpline(controlPts:Array, count:int, result:Array):void
		{
			//不包含起点,包含终点
			for (var i:int=1; i <= count; i++)
			{
				var pt:Point = new Point();
				bezier(i / count, controlPts, pt);
				result.push(pt);
			}
		}
		
		static private function calcCenterPoints(pointList:Array):Array
		{
			const n:int = pointList.length - 1;
			var result:Array = [];
			for(var i:int=0; i<n; i++){
				result.push(calcCenterPoint(pointList[i], pointList[i+1]));
			}
			return result;
		}
		
		static private function calcCenterPoint(a:Point, b:Point):Point
		{
			return new Point(0.5 * (a.x + b.x), 0.5 * (a.y + b.y));
		}
		
		static private const matrix:Matrix = new Matrix();
	}
}