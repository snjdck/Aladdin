package math
{
	public function avg(args:Object):Number
	{
		if(args.length > 0){
			return sum(args) / args.length;
		}
		return 0;
	}
}