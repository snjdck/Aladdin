package tint
{
	/**
	 * alpha不参与计算
	 */
	public function add(c1:uint, c2:uint):uint
	{
		var r1:int = 0xFF & (c1 >> 16);
		var g1:int = 0xFF & (c1 >> 8);
		var b1:int = 0xFF & c1;
		
		var r2:int = 0xFF & (c2 >> 16);
		var g2:int = 0xFF & (c2 >> 8);
		var b2:int = 0xFF & c2;
		
		var r:int = Math.min(r1 + r2, 0xFF);
		var g:int = Math.min(g1 + g2, 0xFF);
		var b:int = Math.min(b1 + b2, 0xFF);
		
		return (r << 16) | (g << 8) | b | 0xFF000000;
	}
}