package array
{
	/** @return added success */
	public function pushIfNotHas(list:Object, item:Object):Boolean
	{
		if(has(list, item)){
			return false;
		}
		push(list, item);
		return true;
	}
}