package stdlib.typecast
{
	public function xml_to_object(xml:*):Object
	{
		if(xml is XMLList){
			return parse_xmllist(xml);
		}
		if(xml.hasComplexContent()){
			return parse_complex_xml(xml);
		}
		return parse_simple_xml(xml);
	}
}

import stdlib.typecast.xml_to_object;

function parse_xmllist(xmllist:XMLList):Object
{
	if(xmllist.length() <= 1){
		return xml_to_object(xmllist[0]);
	}
	var result:Array = [];
	for(var i:int=xmllist.length()-1; i >= 0; i--){
		result[i] = xml_to_object(xmllist[i]);
	}
	return result;
}

function parse_complex_xml(xml:XML):Object
{
	var obj:Object = parse_attributes(xml);
	for each(var child:XML in xml.children()){
		var childName:String = child.name().toString();
		if(childName in obj){
			continue;
		}
		obj[childName] = xml_to_object(xml.child(childName));
	}
	return obj;
}

function parse_simple_xml(xml:XML):Object
{
	var text:String = xml.toString();
	if(xml.attributes().length() <= 0){
		return text;
	}
	var obj:Object = parse_attributes(xml);
	if(text){
		obj._text = text;
	}
	return obj;
}

function parse_attributes(xml:XML):Object
{
	var obj:Object = {};
	for each(var item:XML in xml.attributes()){
		obj[item.name().toString()] = item.toString();
	}
	return obj;
}