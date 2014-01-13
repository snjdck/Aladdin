package snjdck.utils
{
	import flash.geom.Rectangle;
	
	import math.truncate;

	public class AreaUtil
	{
		static public function bindViewInArea(target:Object, area:Object):void
		{
			target.x = bindInArea(target.x, target.width,  area.x, area.width);
			target.y = bindInArea(target.y, target.height, area.y, area.height);
		}
		
		static public function bindInArea(targetPosition:Number, targetSize:Number, areaPosition:Number, areaSize:Number):Number
		{
			return truncate(targetPosition, areaPosition, areaPosition + areaSize - targetSize);
		}
		
		static public function getDragBindingArea(target:Rectangle, area:Rectangle):Rectangle
		{
			var result:Rectangle = new Rectangle();
			
			result.width  = Math.abs(target.width  - area.width);
			result.height = Math.abs(target.height - area.height);
			result.x = (target.width  <= area.width)  ? area.x : (area.right  - target.width);
			result.y = (target.height <= area.height) ? area.y : (area.bottom - target.height);
			
			return result;
		}
	}
}