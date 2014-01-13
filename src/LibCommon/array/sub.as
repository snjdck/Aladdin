package array
{
	/**
	 * [1,2,3,4] sub [3,4,5,6] = [1,2]
	 * @return result
	 */
	public function sub(a:Array, b:Array, result:Array=null):Array
	{
		result ||= [];
		for each(var item:* in a){
			if(!has(b, item)){
				result[result.length] = item;
			}
		}
		return result;
	}
}