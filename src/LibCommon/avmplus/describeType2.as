package avmplus
{
	public function describeType2(target:Object):Object
	{
		var flags:uint = FLASH10_FLAGS | (target is Class ? USE_ITRAITS : 0);
		return describeTypeJSON(target, flags);
	}
}