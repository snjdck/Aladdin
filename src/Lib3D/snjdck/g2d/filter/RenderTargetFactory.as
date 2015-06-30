package snjdck.g2d.filter
{
	import flash.geom.Rectangle;
	
	import snjdck.gpu.asset.GpuRenderTarget;
	import snjdck.gpu.asset.GpuTexture;
	
	public class RenderTargetFactory
	{
		private const targetList:Array = [];
		private const rectList:Array = [];
		
		private var rectW:int;
		private var rectH:int;
		
		private var countW:int;
		private var countH:int;
		
		private var extraW:int;
		private var extraH:int;
		
		public function RenderTargetFactory()
		{
//			createList(500, 500, 21);
//			trace(getRectList().join("\n"));
		}
		
		public function getRectList():Array
		{
			return rectList;
		}
		
		public function getRectAt(index:int):RenderRegion
		{
			return rectList[index];
		}
		
		public function createList(width:int, height:int, count:int):void
		{
			rectW = width;
			rectH = height;
			
			countW = GpuTexture.MAX_SIZE / width;
			countH = GpuTexture.MAX_SIZE / height;
			
			var countPerTarget:int = countW * countH;
			var extraCount:int = count % countPerTarget;
			
			createTargetList(Math.ceil(count / countPerTarget), extraCount);
			createRectList(count, countPerTarget, count - extraCount);
		}
		
		private function createRectList(count:int, countPerTarget:int, fullCount:int):void
		{
			rectList.length = count;
			
			for (var i:int = 0; i < count; ++i)
			{
				var column:int, row:int;
				
				if(i < fullCount){
					column = i % countW;
					row = (i % countPerTarget) / countW;
				}else{
					var index:int = i - fullCount;
					column = index % extraW;
					row = index / extraW;
				}
				
				rectList[i] = createGroup(i / countPerTarget, column, row);
			}
		}
		
		private function createTargetList(targetCount:int, extraCount:int):void
		{
			targetList.length = targetCount;
			
			var targetW:int = countW * rectW;
			var targetH:int = countH * rectH;
			
			var lastIndex:int = targetCount - 1;
			
			for (var i:int = 0; i < lastIndex; ++i){
				targetList[i] = new GpuRenderTarget(targetW, targetH);
			}
			if(extraCount > 0){
				targetList[lastIndex] = createExtraTarget(extraCount);
			}else{
				targetList[lastIndex] = new GpuRenderTarget(targetW, targetH);
			}
		}
		
		private function createExtraTarget(extraCount:int):GpuRenderTarget
		{
			if(extraCount > countW){
				extraH = Math.ceil(extraCount / countW);
				extraW = Math.ceil(extraCount / extraH);
			}else{
				extraW = extraCount;
				extraH = 1;
			}
			return new GpuRenderTarget(extraW * rectW, extraH * rectH);
		}
		
		private function createGroup(targetIndex:int, column:int, row:int):RenderRegion
		{
			var group:RenderRegion = new RenderRegion();
			group.renderTarget = targetList[targetIndex];
			group.rect = new Rectangle(column * rectW, row * rectH, rectW, rectH);
			return group;
		}
		
		public function destroy():void
		{
			while(targetList.length > 0){
				var target:GpuRenderTarget = targetList.pop();
				target.dispose();
			}
			rectList.length = 0;
		}
	}
}