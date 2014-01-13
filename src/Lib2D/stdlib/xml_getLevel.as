package stdlib
{
	/**
	 * @param node XML or XMLList
	 * @return 根节点返回0
	 */
	public function xml_getLevel(node:Object):int
	{
		var level:int = 0;
		
		while(node.parent() is XML){
			++level;
			node = node.parent();
		}
		
		return level;
	}
}