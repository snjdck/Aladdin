package f2d
{
	import flash.display.DisplayObject;

	/**
	 * 从 0 到 180 的值表示顺时针方向旋转；从 0 到 -180 的值表示逆时针方向旋转。 以度为单位。
	 */
	public function lookAtPosition(target:DisplayObject, posX:Number, posY:Number, initRotation:Number=0):void
	{
		var dx:Number = posX - target.x;
		var dy:Number = posY - target.y;
		target.rotation = Math.atan2(dy, dx) * (180 / Math.PI) - initRotation;
	}
}