package f2d
{
	import flash.display.MovieClip;

	/**
	 * movieclip_getChildren(mc, "fish_", 1, 2) => [mc(which name equals "fish_1"), mc(which name equals "fish_2")]
	 */
	public function getChildrenInMc(target:MovieClip, prefix:String, fromIndex:int, toIndex:int):Array
	{
		var children:Array = [];
		for(var i:int=fromIndex; i<=toIndex; i++){
			children.push(target[prefix+i]);
		}
		return children;
	}
}