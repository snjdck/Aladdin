package array
{
	public function getItem(list:Object, key:String, val:Object, field:String=null):*
	{
		for each(var item:* in list){
			if(item[key] == val){
				return field ? item[field] : item;
			}
		}
	}
}