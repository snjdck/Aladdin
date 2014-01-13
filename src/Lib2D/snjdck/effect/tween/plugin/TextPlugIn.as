package snjdck.effect.tween.plugin
{
	internal class TextPlugIn implements IPlugIn
	{
		public function get propName():String
		{
			return "text";
		}
		
		public function hasProp(target:Object):Boolean
		{
			return propName in target;
		}
		
		public function getProp(target:Object):Number
		{
			return Number(target.text);
		}
		
		public function setProp(target:Object, val:Number):void
		{
			target.text = val.toFixed();
		}
	}
}