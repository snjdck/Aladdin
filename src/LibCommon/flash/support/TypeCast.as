package flash.support
{
	import flash.reflection.getTypeName;
	import flash.utils.ByteArray;

	final public class TypeCast
	{
		static public function CastClsToStr(clsRefOrClsName:*):String
		{
			if(clsRefOrClsName is Class){
				return getTypeName(clsRefOrClsName);
			}else if(clsRefOrClsName is String){
				return clsRefOrClsName;
			}
			throw new ArgumentError("input must be 'Class' or 'String'!");
		}
		
		static public function CastBinToStr(bin:Class):String
		{
			var ba:ByteArray = new bin();
			return ba.toString();
		}
		
		static public function CastListToDict(list:Array, keyField:String, valueField:String=null, output:Object=null):Object
		{
			output ||= {};
			for each(var item:Object in list){
				output[item[keyField]] = valueField ? item[valueField] : item;
			}
			return output;
		}
		
		static public function CastVectorToArray(vector:Object):Array
		{
			var result:Array = [];
			for each(var item:Object in vector){
				result[result.length] = item;
			}
			return result;
		}
	}
}