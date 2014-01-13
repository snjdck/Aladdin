package tint
{
	public function scale(color:uint, s:Number):uint
	{
		var a:int = s * (0xFF & (color >> 24));
		var r:int = s * (0xFF & (color >> 16));
		var g:int = s * (0xFF & (color >> 8));
		var b:int = s * (0xFF & color);
		
		return (a << 24) | (r << 16) | (g << 8) | b;
	}
}