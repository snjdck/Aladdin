package f2d
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public function addChild(parent:DisplayObjectContainer, child:DisplayObject, px:Number=0, py:Number=0, index:int=-1):void
	{
		moveTo(child, px, py);
		
		if(index >= 0){
			parent.addChildAt(child, index);
		}else{
			parent.addChild(child);
		}
	}
}