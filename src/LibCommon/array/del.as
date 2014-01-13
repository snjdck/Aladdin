package array
{
	public function del(list:Object, item:Object):*
	{
		return delAt(list, list.indexOf(item));
	}
}