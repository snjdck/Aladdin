package f2d
{
	import flash.display.DisplayObject;

	/**
	 * @see display_lookAtPosition
	 */	
	public function lookAtObject(target:DisplayObject, object:Object, initRotation:Number=0):void
	{
		lookAtPosition(target, object.x, object.y, initRotation);
	}
}