package flash.support
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;

	final public class Layout
	{
		static public function CenterX(target:Object, targetWidth:Number, parentWidth:Number, offsetX:Number=0):void
		{
			assert(target.hasOwnProperty("x"));
			target.x = offsetX + 0.5 * (parentWidth - targetWidth);
		}
		
		static public function CenterY(target:Object, targetHeight:Number, parentHeight:Number, offsetY:Number=0):void
		{
			assert(target.hasOwnProperty("y"));
			target.y = offsetY + 0.5 * (parentHeight - targetHeight);
		}
		
		static public function Center(target:Object, targetWidth:Number, targetHeight:Number, parentWidth:Number, parentHeight:Number, offsetX:Number=0, offsetY:Number=0):void
		{
			CenterX(target, targetWidth, parentWidth, offsetX);
			CenterY(target, targetHeight, parentHeight, offsetY);
		}
		
		static public function Bottom(target:Object, targetHeight:Number, parentHeight:Number, offsetY:Number=0):void
		{
			assert(target.hasOwnProperty("y"));
			target.y = offsetY + parentHeight - targetHeight;
		}
		
		static public function Right(target:Object, targetWidth:Number, parentWidth:Number, offsetX:Number=0):void
		{
			assert(target.hasOwnProperty("x"));
			target.x = offsetX + parentWidth - targetWidth;
		}
		
		static public function BottomRight(target:Object, targetWidth:Number, targetHeight:Number, parentWidth:Number, parentHeight:Number, offsetX:Number=0, offsetY:Number=0):void
		{
			Bottom(target, targetHeight, parentHeight, offsetY);
			Right(target, targetWidth, parentWidth, offsetX);
		}
		
		static public function CenterViewX(target:Object, parentWidth:Number, offsetX:Number=0):void
		{
			assert(target.hasOwnProperty("width"));
			CenterX(target, target.width, parentWidth, offsetX);
		}
		
		static public function CenterViewY(target:Object, parentHeight:Number, offsetY:Number=0):void
		{
			assert(target.hasOwnProperty("height"));
			CenterY(target, target.height, parentHeight, offsetY);
		}
		
		static public function CenterView(target:Object, parentWidth:Number, parentHeight:Number, offsetX:Number=0, offsetY:Number=0):void
		{
			CenterViewX(target, parentWidth, offsetX);
			CenterViewY(target, parentHeight, offsetY);
		}
		
		static public function CenterDisplayX(target:DisplayObject, parentWidth:Number):void
		{
			var rect:Rectangle = target.getRect(target);
			CenterViewX(target, parentWidth, -rect.x);
		}
		
		static public function CenterDisplayY(target:DisplayObject, parentHeight:Number):void
		{
			var rect:Rectangle = target.getRect(target);
			CenterViewY(target, parentHeight, -rect.y);
		}
		
		static public function CenterDisplay(target:DisplayObject, parentWidth:Number, parentHeight:Number):void
		{
			var rect:Rectangle = target.getRect(target);
			CenterViewX(target, parentWidth, -rect.x);
			CenterViewY(target, parentHeight, -rect.y);
		}
		
		static public function CenterDisplayInParent(target:DisplayObject, parent:DisplayObjectContainer=null, widthFlag:Boolean=true, heightFlag:Boolean=true):void
		{
			if(null == parent){
				parent = target.parent;
			}
			if(null == parent){
				return;
			}
			if(widthFlag){
				CenterDisplayX(target, parent.width);
			}
			if(heightFlag){
				CenterDisplayY(target, parent.height);
			}
		}
		
		/** @return ratio x (outer.width - inner.width) */
		static public function AlignRegionX(outer:Object, inner:Object, ratio:Number=0.5):Number
		{
			assert(outer.hasOwnProperty("width"));
			assert(inner.hasOwnProperty("width"));
			return ratio * (outer.width - inner.width);
		}
		
		/** @return ratio x (outer.height - inner.height) */
		static public function AlignRegionY(outer:Object, inner:Object, ratio:Number=0.5):Number
		{
			assert(outer.hasOwnProperty("height"));
			assert(inner.hasOwnProperty("height"));
			return ratio * (outer.height - inner.height);
		}
		
		/**
		 * result.x = alignRegionX(outer, inner, ratioX);<br/>
		 * result.y = alignRegionY(outer, inner, ratioY);
		 */
		static public function AlignRegion(outer:Object, inner:Object, result:Object, ratioX:Number=0.5, ratioY:Number=0.5):void
		{
			assert(result.hasOwnProperty("x"));
			result.x = AlignRegionX(outer, inner, ratioX);
			
			assert(result.hasOwnProperty("y"));
			result.y = AlignRegionY(outer, inner, ratioY);
		}
	}
}