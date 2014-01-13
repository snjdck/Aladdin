package tint
{
	public function rgb565_to_argb8888(color:uint):uint
	{
		var r:int = ((color >> 11) & 0x1F) << 3;
		var g:int = ((color >> 5)  & 0x3F) << 2;
		var b:int = (color & 0x1F) << 3;
		
		return 0xFF000000 | (r << 16) | (g << 8) | b;
	}
}