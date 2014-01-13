package snjdck.effect.tween.plugin
{
	internal interface IPlugIn
	{
		function get propName():String;
		function hasProp(target:Object):Boolean;
		function getProp(target:Object):Number;
		function setProp(target:Object, val:Number):void;
	}
}