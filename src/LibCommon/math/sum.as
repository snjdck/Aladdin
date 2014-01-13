package math
{
	public function sum(args:Object):Number
	{
		var result:Number = 0;
		for each(var i:Number in args){
			result += isNaN(i) ? 0 : i;
		}
		return result;
	}
}