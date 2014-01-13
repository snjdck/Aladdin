package stdlib.typecast
{
	public function list_to_dict(list:Array, keyField:String, valueField:String=null, output:Object=null):Object
	{
		output ||= {};
		for each(var item:Object in list){
			output[item[keyField]] = valueField ? item[valueField] : item;
		}
		return output;
	}
}