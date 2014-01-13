package org.xmlui.support
{
	public function copyXmlPropIfExist(target:Object, source:XML, sourceProp:String, targetProp:String=null):void
	{
		if(!source.hasOwnProperty("@"+sourceProp)){
			return;
		}
		if(null == targetProp){
			targetProp = sourceProp;
		}
		var value:String = source.attribute(sourceProp);
		target[targetProp] = convertStrToVal(value);
	}
}