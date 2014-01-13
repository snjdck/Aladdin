package array
{
	/**
	 * 迭代数组中每两个不同的元素
	 * 如果handler(a, b)返回true,则终止迭代循环
	 */
	public function eachPair(list:Array, handler:Function):void
	{
		var n:int = list.length;
		var i:int, j:int;
		
		loop:
		for(i=0; i<n-1; i++){
			for(j=i+1; j<n; j++){
				if(handler(list[i], list[j])){
					break loop;
				}
			}
		}
	}
}