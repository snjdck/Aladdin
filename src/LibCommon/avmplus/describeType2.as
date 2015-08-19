package avmplus
{
	import flash.reflection.getType;

	public function describeType2(target:Object):Object
	{
		var instanceInfo:Object;
		var classInfo:Object;
		if(target is Class){
			instanceInfo = describeTypeJSON(target, FLASH10_FLAGS | USE_ITRAITS);
			classInfo = describeTypeJSON(target, FLASH10_FLAGS);
		}else{
			instanceInfo = describeTypeJSON(target, FLASH10_FLAGS);
			classInfo = describeTypeJSON(getType(target), FLASH10_FLAGS);
		}
		instanceInfo.traitsStatic = classInfo.traits;
		return instanceInfo;
	}
}