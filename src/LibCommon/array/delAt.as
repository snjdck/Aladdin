package array
{
	/**
	 * @param list Array or Vector
	 */
	public function delAt(list:Object, index:int):*
	{
		if(0 <= index && index < list.length){
			return list.splice(index, 1)[0];
		}
	}
}