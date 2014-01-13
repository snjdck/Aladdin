package f2d
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public function traverse(target:DisplayObject, handler:Function):void
	{
		handler(target);
		var container:DisplayObjectContainer = target as DisplayObjectContainer;
		if(null == container){
			return;
		}
		for(var i:int=container.numChildren-1; i>=0; i--){
			traverse(container.getChildAt(i), handler);
		}
	}
}