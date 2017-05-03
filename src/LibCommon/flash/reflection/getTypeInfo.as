package flash.reflection
{
	import flash.reflection.typeinfo.TypeInfo;
	import flash.utils.getQualifiedClassName;
	
	import avmplus.describeType2;

	public function getTypeInfo(target:Object):TypeInfo
	{
		var typeName:String = getQualifiedClassName(target);
		return cache[typeName] ||= new TypeInfo(describeType2(target));
	}
}

const cache:Object = {};