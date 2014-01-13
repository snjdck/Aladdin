package stdlib.common
{
	/**
	 * 将parent中存在而child中不存在的属性,从parent复制到child中.
	 * @return child
	 */
	public function inheritProps(child:Object, parent:Object):*
	{
		for(var prop:* in parent){
			if(!(prop in child)){
				child[prop] = parent[prop];
			}
		}
		return child;
	}
}