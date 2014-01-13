package snjdck.effect.tween.plugin
{
	internal class ScalePlugIn implements IPlugIn
	{
		public function get propName():String
		{
			return "scale";
		}
		
		public function hasProp(target:Object):Boolean
		{
			return ("scaleX" in target) && ("scaleY" in target);
		}
		
		public function getProp(target:Object):Number
		{
			return target.scaleX;
		}
		
		public function setProp(target:Object, val:Number):void
		{
			target.scaleX = target.scaleY = val;
		}
	}
}