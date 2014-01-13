package stdlib.graphics.path
{
	import flash.display.Graphics;
	import flash.display.GraphicsPathCommand;
	import flash.display.GraphicsPathWinding;
	
	import stdlib.graphics.IPath;
	
	public class Path implements IPath
	{
		/**
		 * @param vertexList 顶点列表
		 * @param closeFlag 是否将路径闭合
		 */
		static public function Create(vertexList:Array, closeFlag:Boolean=false):IPath
		{
			var path:Path = new Path();
			var vertex:Object;
			
			vertex = vertexList[0];
			path.moveTo(vertex.x, vertex.y);
			
			for(var i:int=1; i<vertexList.length; i++){
				vertex = vertexList[i];
				path.lineTo(vertex.x, vertex.y);
			}
			
			if(closeFlag){
				vertex = vertexList[0];
				path.lineTo(vertex.x, vertex.y);
			}
			
			return path;
		}
		
		public var commands:Vector.<int>;
		public var data:Vector.<Number>;
		public var winding:String;
		
		public function Path(commands:Vector.<int>=null, data:Vector.<Number>=null)
		{
			this.commands = commands || new Vector.<int>();
			this.data = data || new Vector.<Number>();
			this.winding = GraphicsPathWinding.EVEN_ODD;
		}
		
		public function draw(target:Graphics):void
		{
			target.drawPath(commands, data, winding);
		}
		
		public function moveTo(x:Number, y:Number):void
		{
			commands.push(GraphicsPathCommand.MOVE_TO);
			data.push(x, y);
		}
		
		public function lineTo(x:Number, y:Number):void
		{
			commands.push(GraphicsPathCommand.LINE_TO);
			data.push(x, y);
		}
		
		/**
		 * 二次贝塞尔曲线	(1-t)^2*P0 + 2*(1-t)*t*P1 + t^2*P2, t=[0,1]
		 */
		public function curveTo(controlX:Number, controlY:Number, anchorX:Number, anchorY:Number):void
		{
			commands.push(GraphicsPathCommand.CURVE_TO);
			data.push(controlX, controlY, anchorX, anchorY);
		}
		
		/**
		 * 三次贝塞尔曲线	(1-t)^3*P0 + 3*(1-t)^2*t*P1 + 3*(1-t)*t^2*P2 + t^3*P3, t=[0,1]
		 */
		public function cubicCurveTo(controlX1:Number, controlY1:Number, controlX2:Number, controlY2:Number, anchorX:Number, anchorY:Number):void
		{
			commands.push(6);//GraphicsPathCommand.CUBIC_CURVE_TO
			data.push(controlX1, controlY1, controlX2, controlY2, anchorX, anchorY);
		}
		
		public function wideMoveTo(x:Number, y:Number):void
		{
			commands.push(GraphicsPathCommand.WIDE_MOVE_TO);
			data.push(0, 0, x, y);
		}
		
		public function wideLineTo(x:Number, y:Number):void
		{
			commands.push(GraphicsPathCommand.WIDE_LINE_TO);
			data.push(0, 0, x, y);
		}
		
		public function clear():void
		{
			commands.length = 0;
			data.length = 0;
		}
		
		public function offset(dx:Number, dy:Number):void
		{
			for(var i:int=0; i<data.length; i+=2){
				data[i] += dx;
				data[i+1] += dy;
			}
		}
		
		public function curveBy(controlX:Number, controlY:Number, anchorX:Number, anchorY:Number):void
		{
			var posX:Number = data[data.length-2];
			var posY:Number = data[data.length-1];
			
			curveTo(
				2 * controlX - (posX + anchorX) * 0.5,
				2 * controlY - (posY + anchorY) * 0.5,
				anchorX, anchorY
			);
		}
		
		public function drawLine(startX:Number, startY:Number, endX:Number, endY:Number):void
		{
			moveTo(startX, startY);
			lineTo(endX, endY);
		}
		
		public function drawHorizontalLine(py:Number, startX:Number, endX:Number):void
		{
			drawLine(startX, py, endX, py);
		}
		
		public function drawVerticalLine(px:Number, startY:Number, endY:Number):void
		{
			drawLine(px, startY, px, endY);
		}
		
		public function drawRect(x:Number, y:Number, width:Number, height:Number):void
		{
			moveTo(x, y);
			lineTo(x+width, y);
			lineTo(x+width, y+height);
			lineTo(x, y+height);
			lineTo(x, y);
		}
		
		/**
		 * 据说使用"0.551784"更精确
		 */
		static private const MAGIC_NUMBER:Number = 4 * (Math.SQRT2 - 1) / 3;
		
		public function drawCircle(x:Number, y:Number, radius:Number):void
		{
			var offset:Number = radius * MAGIC_NUMBER;
			
			moveTo(x, y-radius);
			cubicCurveTo(x+offset, y-radius, x+radius, y-offset, x+radius, y);
			cubicCurveTo(x+radius, y+offset, x+offset, y+radius, x, y+radius);
			cubicCurveTo(x-offset, y+radius, x-radius, y+offset, x-radius, y);
			cubicCurveTo(x-radius, y-offset, x-offset, y-radius, x, y-radius);
		}
	}
}