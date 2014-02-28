package flash.reflection
{
	import avmplus.describeType2;
	
	import flash.reflection.typeinfo.TypeInfo;

	public function getTypeInfo(target:Object):TypeInfo
	{
		var typeName:String = getTypeName(target);
		return cache[typeName] ||= new TypeInfo(describeType2(target));
	}
}

const cache:Object = {};