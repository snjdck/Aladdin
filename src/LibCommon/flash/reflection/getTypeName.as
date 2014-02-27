package flash.reflection
{
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;

	public function getTypeName(target:Object, shortFlag:Boolean=false, parentFlag:Boolean=false):String
	{
		var fullName:String = parentFlag ? getQualifiedSuperclassName(target) : getQualifiedClassName(target);
		if(shortFlag){
			var index:int = fullName.lastIndexOf("::");
			if(index != -1){
				return fullName.slice(index+2);
			}
		}
		return fullName;
	}
}