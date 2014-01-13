package snjdck.utils
{
	import flash.display.DisplayObject;
	
	import f2d.layout.centerDisplayInParent;
	
	import snjdck.effect.tween.impl.Tween;
	import snjdck.effect.tween.TweenEase;

	final public class TweenUtil
	{
		static public function ShowPanel(target:DisplayObject):void
		{
			new Tween(target, 500, {"scale":[0.6, 1], "alpha":[0, 1]}, TweenEase.BackOut, null, [centerDisplayInParent, target]).start();
		}
		
		static public function HidePanel(target:DisplayObject, onEnd:Object=null):void
		{
			new Tween(target, 500, {"scale":[1, 0.6], "alpha":[1, 0]}, TweenEase.BackIn, onEnd, [centerDisplayInParent, target]).start();
		}
	}
}