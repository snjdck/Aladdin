package flash.factory
{
	import flash.display.Graphics;
	import flash.display.Sprite;

	public function newBox(width:Number, height:Number, fillColor:uint=0xFF0000FF, borderColor:uint=0xFFFFFFFF):Sprite
	{
		var sp:Sprite = new Sprite();
		
		var g:Graphics = sp.graphics;
		g.lineStyle(1, borderColor & 0xFFFFFF, (borderColor >>> 24)/0xFF);
		g.beginFill(fillColor & 0xFFFFFF, (fillColor >>> 24)/0xFF);
		g.drawRect(0, 0, width, height);
		g.endFill();
		
		return sp;
	}
}