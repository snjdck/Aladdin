package stdlib.typecast
{
	import stdlib.reflection.getTypeName;

	public function castClsRefOrClsNameToString(clsRefOrClsName:*):String
	{
		if(clsRefOrClsName is Class){
			return getTypeName(clsRefOrClsName);
		}else if(clsRefOrClsName is String){
			return clsRefOrClsName;
		}
		throw new ArgumentError("input must be 'Class' or 'String'!");
	}
}