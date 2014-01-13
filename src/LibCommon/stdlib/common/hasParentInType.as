package stdlib.common
{
	import flash.display.DisplayObject;

	public function hasParentInType(target:DisplayObject, types:Array):Boolean
	{
		while(target){
			if(isType(target, types)){
				return true;
			}
			target = target.parent;
		}
		return false;
	}
}