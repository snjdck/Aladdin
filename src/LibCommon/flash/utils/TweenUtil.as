package flash.utils
{
	import flash.support.Layout;
	
	import flash.display.DisplayObject;
	
	import snjdck.effect.tween.TweenEase;
	import snjdck.effect.tween.Tween;

	final public class TweenUtil
	{
		static public function ShowPanel(target:DisplayObject):void
		{
			new Tween(target, 500, {"scale":[0.6, 1], "alpha":[0, 1]}, TweenEase.BackOut, null, [Layout.CenterDisplayInParent, target]).start();
		}
		
		static public function HidePanel(target:DisplayObject, onEnd:Object=null):void
		{
			new Tween(target, 500, {"scale":[1, 0.6], "alpha":[1, 0]}, TweenEase.BackIn, onEnd, [Layout.CenterDisplayInParent, target]).start();
		}
	}
}