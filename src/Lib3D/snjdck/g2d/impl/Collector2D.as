package snjdck.g2d.impl
{
	import snjdck.g2d.ns_g2d;
	import snjdck.g2d.core.IDisplayObject2D;
	import snjdck.g2d.render.DrawUnit2D;
	
	import stdlib.components.ObjectPool;
	
	use namespace ns_g2d;

	public class Collector2D
	{
		static private const drawUnitPool:ObjectPool = new ObjectPool(DrawUnit2D);
		
		protected const quadList:Vector.<DrawUnit2D> = new Vector.<DrawUnit2D>();
		
		public function Collector2D()
		{
		}
		
		public function clear():void
		{
			while(quadList.length > 0){
				var drawUnit:DrawUnit2D = quadList.pop();
				drawUnit.clear();
				drawUnitPool.setObjectIn(drawUnit);
			}
		}
		
		final public function getFreeDrawUnit():DrawUnit2D
		{
			return drawUnitPool.getObjectOut();
		}
		
		public function addDrawUnit(drawUnit:DrawUnit2D):void
		{
			var target:IDisplayObject2D = drawUnit.target;
			
			drawUnit.index = quadList.length;
			drawUnit.layer = target.layer;
			
			quadList[quadList.length] = drawUnit;
		}
		
		[Inline]
		public function onFrameBegin():void
		{
			quadList.sort(_sortQuadList);
			calcDrawUnitZ();
		}
		
		[Inline]
		private function calcDrawUnitZ():void
		{
			const quadCount:int = quadList.length;
			const factor:Number = (quadCount > 1) ? (1 / (quadCount - 1)) : 1;
			for(var i:int=0; i<quadCount; i++){
				var drawUnit:DrawUnit2D = quadList[i];
				drawUnit.z = factor * i;
			}
		}
		
		/**
		 * index值绝对不可能相同
		 * z值小的在前面(离屏幕近的在前面)
		 */
		static private function _sortQuadList(left:DrawUnit2D, right:DrawUnit2D):int
		{
			if(left.layer != right.layer){
				return left.layer > right.layer ? -1 : 1;
			}
			return left.index > right.index ? -1 : 1;
		}
	}
}