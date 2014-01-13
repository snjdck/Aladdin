package stdlib
{
	import stdlib.reflection.getTypeName;

	public function object_createUniqueName(target:Object):String
	{
		return getTypeName(target, true) + "_" + (counter++).toString();
	}
}

var counter:uint = 0;