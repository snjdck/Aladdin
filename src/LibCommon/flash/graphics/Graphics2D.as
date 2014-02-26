package flash.graphics
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	final public class Graphics2D
	{
		private var target:Graphics;
		
		public function Graphics2D(target:Graphics)
		{
			this.target = target;
		}
		
		public function getTarget():Graphics
		{
			return target;
		}
		
		public function copyFrom(g:Graphics):void
		{
			target.copyFrom(g);
		}
		
		public function clear():void
		{
			target.clear();
		}
		
		/** 绘制路径 **/
		public function drawPath(path:IPath):void
		{
			path.draw(target);
		}
		
		/** 设置笔触 **/
		public function setPen(pen:IPen):void
		{
			if(null == pen){
				target.lineStyle();
			}else{
				pen.apply(target);
			}
		}
		
		/** 设置笔刷 **/
		public function beginFill(brush:IBrush):void
		{
			brush.beginFill(target);
		}
		
		public function endFill():void
		{
			target.endFill();
		}
	}
}