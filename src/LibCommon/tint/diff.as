package tint
{
	public function diff(c1:uint, c2:uint):uint
	{
		var r1:int = 0xFF & (c1 >> 16);
		var g1:int = 0xFF & (c1 >> 8);
		var b1:int = 0xFF & c1;
		
		var r2:int = 0xFF & (c2 >> 16);
		var g2:int = 0xFF & (c2 >> 8);
		var b2:int = 0xFF & c2;
		
		return Math.abs(r1-r2) + Math.abs(g1-g2) + Math.abs(b1-b2);
	}
}