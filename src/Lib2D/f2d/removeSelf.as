package f2d
{
	import flash.display.DisplayObject;

	public function removeSelf(target:DisplayObject):void
	{
		if(target && target.parent){
			target.parent.removeChild(target);
		}
	}
}