package tint
{
	public function argb8888_to_rgb565(color:uint):uint
	{
		var r:int = (0xFF & (color >> 16)) >> 3;
		var g:int = (0xFF & (color >> 8))  >> 2;
		var b:int = (0xFF & color) >> 3;
		
		return (r << 11) | (g << 5) | b;
	}
}