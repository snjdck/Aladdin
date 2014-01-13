package tint
{
	public function rgb555_to_argb8888(color:uint):uint
	{
		var r:int = ((color >> 11) & 0x1F) << 3;
		var g:int = ((color >> 6)  & 0x1F) << 3;
		var b:int = ((color >> 1)  & 0x1F) << 3;
		
		return 0xFF000000 | (r << 16) | (g << 8) | b;
	}
}