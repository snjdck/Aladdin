package f2d
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public function addChildren(parent:DisplayObjectContainer, args:Array):void
	{
		if(null == args || args.length < 1){
			return;
		}
		for each(var child:DisplayObject in args){
			parent.addChild(child);
		}
	}
}