package stdlib.common
{
	/**
	 * 将from中的属性复制到to中
	 * @param all 是复制全部属性(true),还是复制to中存在的属性(false).<br>此参数主要用于防止复制属性时发生错误,因为封闭对象不能动态添加属性.<br>
	 * 通过此函数可实现:clone,merge等功能.
	 * @return to
	 */
	public function copyProps(to:Object, from:Object, all:Boolean=true):*
	{
		for(var prop:* in from){
			if(all || (prop in to)){
				to[prop] = from[prop];
			}
		}
		return to;
	}
}