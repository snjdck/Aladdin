package array
{
	public function delWhen(list:Array, key:String, val:Object):*
	{
		for(var index:* in list){
			if(list[index][key] == val){
				return delAt(list, index);
			}
		}
	}
}