package array
{
	public function getItemList(list:Object, key:String, val:Object, field:String=null):Array
	{
		var result:Array = [];
		for each(var item:* in list){
			if(item[key] == val){
				result[result.length] = (field ? item[field] : item);
			}
		}
		return result;
	}
}