package avmplus
{
	import stdlib.reflection.getTypeName;
	
	import stdlib.reflection.typeinfo.TypeInfo;

	public function getTypeInfo(target:Object):TypeInfo
	{
		var typeName:String = getTypeName(target);
		var flags:uint = FLASH10_FLAGS | (target is Class ? USE_ITRAITS : 0);
		return cache[typeName] ||= new TypeInfo(describeTypeJSON(target, flags));
	}
}

const cache:Object = {};