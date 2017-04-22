package snjdck.agalc.helper
{
	public function flags2writeMask(flags:String):uint
	{
		if(null == flags || flags.length <= 0){
			return 0xF;//1111
		}
		
		var writeMask:uint = 0;
		for(var i:int=0, n:int=flags.length; i<n; ++i)
			writeMask |= 1 << char2val(flags, i);
		return writeMask;
	}
}