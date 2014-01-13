package f2d.layout
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public function centerDisplayInParent(target:DisplayObject, parent:DisplayObjectContainer=null, widthFlag:Boolean=true, heightFlag:Boolean=true):void
	{
		if(null == parent){
			parent = target.parent;
		}
		if(null == parent){
			return;
		}
		if(widthFlag){
			centerDisplayX(target, parent.width);
		}
		if(heightFlag){
			centerDisplayY(target, parent.height);
		}
	}
}