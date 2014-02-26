package flash.bitmap
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	public function drawMC(shape:DisplayObject, output:BitmapData=null):BitmapData
	{
		const rect:Rectangle = shape.getBounds(shape);
		const matrix:Matrix = new Matrix();
		
		matrix.tx = -rect.x;
		matrix.ty = -rect.y;
		
		output ||= new BitmapData(rect.width, rect.height, true, 0);
		output.draw(shape, matrix);
		
		return output;
	}
}