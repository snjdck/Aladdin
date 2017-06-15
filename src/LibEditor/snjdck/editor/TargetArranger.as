package snjdck.editor
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;

	public class TargetArranger
	{
		private var targetList:Array;
		private var viewWidth:int;
		private var viewHeight:int;
		
		public function TargetArranger(targetList:Array, viewWidth:int, viewHeight:int)
		{
			this.targetList = targetList;
			this.viewWidth = viewWidth;
			this.viewHeight = viewHeight;
		}
		
		private function calcRect():Rectangle
		{
			var minX:Number = Number.MAX_VALUE;
			var minY:Number = Number.MAX_VALUE;
			var maxX:Number = Number.MIN_VALUE;
			var maxY:Number = Number.MIN_VALUE;
			for each(var target:DisplayObject in targetList){
				var right:Number = target.x + target.width;
				var bottom:Number = target.y + target.height;
				if(minX > target.x){
					minX = target.x;
				}
				if(minY > target.y){
					minY = target.y;
				}
				if(maxX < right){
					maxX = right;
				}
				if(maxY < bottom){
					maxY = bottom;
				}
			}
			return new Rectangle(minX, minY, maxX - minX, maxY - minY);
		}
		
		public function alignLeft(stageFlag:Boolean):void
		{
			var target:DisplayObject;
			if(stageFlag){
				for each(target in targetList){
					target.x = 0;
				}
			}else{
				var rect:Rectangle = calcRect();
				for each(target in targetList){
					target.x = rect.x;
				}
			}
		}
		
		public function alignRight(stageFlag:Boolean):void
		{
			var target:DisplayObject;
			if(stageFlag){
				for each(target in targetList){
					target.x = viewWidth - target.width;
				}
			}else{
				var rect:Rectangle = calcRect();
				for each(target in targetList){
					target.x = rect.right - target.width;
				}
			}
		}
		
		public function alignTop(stageFlag:Boolean):void
		{
			var target:DisplayObject;
			if(stageFlag){
				for each(target in targetList){
					target.y = 0
				}
			}else{
				var rect:Rectangle = calcRect();
				for each(target in targetList){
					target.y = rect.y;
				}
			}
		}
		
		
		public function alignBottom(stageFlag:Boolean):void
		{
			var target:DisplayObject;
			if(stageFlag){
				for each(target in targetList){
					target.y = viewHeight - target.height;
				}
			}else{
				var rect:Rectangle = calcRect();
				for each(target in targetList){
					target.y = rect.bottom - target.height;
				}
			}
		}
		
		public function alignCenterX():void
		{
			var target:DisplayObject;
			for each(target in targetList){
				target.x = (viewWidth - target.width) * 0.5;
			}
		}
		
		public function alignCenterY():void
		{
			var target:DisplayObject;
			for each(target in targetList){
				target.y = (viewHeight - target.height) * 0.5;
			}
		}
		
		public function averageGapX():void
		{
			if(targetList.length <= 1){
				return;
			}
			var rect:Rectangle = calcRect();
			var gap:Number = (rect.width - getTotalWidth()) / (targetList.length - 1);
			targetList.sortOn("x", Array.NUMERIC);
			var offset:Number = rect.x;
			for each(var target:DisplayObject in targetList){
				target.x = offset;
				offset += target.width + gap;
			}
		}
		
		public function averageGapY():void
		{
			if(targetList.length <= 1){
				return;
			}
			var rect:Rectangle = calcRect();
			var gap:Number = (rect.height - getTotalHeight()) / (targetList.length - 1);
			targetList.sortOn("y", Array.NUMERIC);
			var offset:Number = rect.y;
			for each(var target:DisplayObject in targetList){
				target.y = offset;
				offset += target.height + gap;
			}
		}
		
		private function getTotalWidth():Number
		{
			var result:Number = 0;
			for each(var target:DisplayObject in targetList){
				result += target.width;
			}
			return result;
		}
		
		private function getTotalHeight():Number
		{
			var result:Number = 0;
			for each(var target:DisplayObject in targetList){
				result += target.height;
			}
			return result;
		}
	}
}