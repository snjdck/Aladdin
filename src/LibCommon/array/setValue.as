package array
{
	public function setValue(list:Object, fromIndex:int, args:Array):void
	{
		copy(args, list, args.length, 0, fromIndex);
	}
}