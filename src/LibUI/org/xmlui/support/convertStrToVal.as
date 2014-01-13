package org.xmlui.support
{
	public function convertStrToVal(str:String):*
	{
		if("true" == str){
			return true;
		}
		if("false" == str){
			return false;
		}
		if(/^[+\-]?(\d+|0[xX][0-9a-fA-F]+)$/.test(str)){
			return parseInt(str);
		}
		if(/^[+\-]?\d+\.\d+$/.test(str)){
			return parseFloat(str);
		}
		return str;
	}
}