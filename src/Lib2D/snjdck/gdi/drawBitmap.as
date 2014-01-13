package snjdck.gdi
{
	import flash.display.BitmapData;
	import flash.display.Graphics;

	public function drawBitmap(g:Graphics, bmd:BitmapData, x:Number, y:Number, width:Number, height:Number, offsetX:Number=0, offsetY:Number=0):void
	{
		matrix.tx = x - offsetX;
		matrix.ty = y - offsetY;
		
		g.beginBitmapFill(bmd, matrix);
		g.drawRect(x, y, width, height);
		g.endFill();
	}
}

import flash.geom.Matrix;

const matrix:Matrix = new Matrix();