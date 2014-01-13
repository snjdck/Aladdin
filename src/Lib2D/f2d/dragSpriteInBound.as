package f2d
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	public function dragSpriteInBound(target:Sprite, bound:Rectangle):void
	{
		var rect:Rectangle = target.getRect(target.parent);
		
		target.startDrag(false, new Rectangle(
			target.x - (rect.right - bound.width),
			target.y - (rect.bottom - bound.height),
			target.width - bound.width,
			target.height - bound.height
		));
	}
}