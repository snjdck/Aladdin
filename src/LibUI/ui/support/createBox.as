package ui.support
{
	import flash.display.Graphics;
	import flash.display.Sprite;

	public function createBox(width:Number, height:Number, color:uint=0x000000, alpha:Number=1, x:Number=0, y:Number=0):Sprite
	{
		var sp:Sprite = new Sprite();
		
		var g:Graphics = sp.graphics;
		g.beginFill(color, alpha);
		g.drawRect(0, 0, width, height);
		g.endFill();
		
		sp.x = x;
		sp.y = y;
		
		return sp;
	}
}