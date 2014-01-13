package math
{
	/** 如果val是int,uint,Number则返回true */
	public function isNumber(val:*):Boolean
	{
		return (typeof val) == "number";
	}
}