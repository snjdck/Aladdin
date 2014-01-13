package array
{
	public function count(list:Array, val:Object):int
	{
		var n:int = 0;
		for each(var item:* in list){
			if(val == item){
				++n;
			}
		}
		return n;
	}
}