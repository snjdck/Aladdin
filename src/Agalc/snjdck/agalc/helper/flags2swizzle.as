package snjdck.agalc.helper
{
	public function flags2swizzle(flags:String):uint
	{
		if(null == flags || flags.length <= 0){
			return 0xE4;//03-02-01-00
		}
		
		var swizzle:uint = 0;
		var shift:int;
		
		for(var i:int=0, n:int=flags.length; i<4; ++i){
			if(i < n){
				shift = char2val(flags, i);
			}
			swizzle |= shift << (i << 1);
		}
		
		return swizzle;
	}
}