package f2d
{
	import flash.display.DisplayObjectContainer;

	public function getChildren(parent:DisplayObjectContainer, fromIndex:int=0, toIndex:int=-1):Array
	{
		if(toIndex < 0){
			toIndex = parent.numChildren;
		}
		
		var children:Array = [];
		while(fromIndex < toIndex){
			children[children.length] = parent.getChildAt(fromIndex++);
		}
		return children;
	}
}