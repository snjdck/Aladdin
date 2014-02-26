package flash.xml
{
	final public class XmlUtil
	{
		/**
		 * @param node XML or XMLList
		 * @return 根节点返回0
		 */
		static public function GetLevel(node:Object):int
		{
			var level:int = 0;
			
			while(node.parent() is XML){
				++level;
				node = node.parent();
			}
			
			return level;
		}
		
		static public function CastToDict(xml:*):Object
		{
			if(xml is XMLList){
				return ParseXmlList(xml);
			}
			if(xml.hasComplexContent()){
				return ParseComplexXml(xml);
			}
			return ParseSimpleXml(xml);
		}
		
		static private function ParseXmlList(xmllist:XMLList):Object
		{
			if(xmllist.length() <= 1){
				return CastToDict(xmllist[0]);
			}
			var result:Array = [];
			for(var i:int=xmllist.length()-1; i >= 0; i--){
				result[i] = CastToDict(xmllist[i]);
			}
			return result;
		}
		
		static private function ParseComplexXml(xml:XML):Object
		{
			var obj:Object = ParseAttributes(xml);
			for each(var child:XML in xml.children()){
				var childName:String = child.name().toString();
				if(childName in obj){
					continue;
				}
				obj[childName] = CastToDict(xml.child(childName));
			}
			return obj;
		}
		
		static private function ParseSimpleXml(xml:XML):Object
		{
			var text:String = xml.toString();
			if(xml.attributes().length() <= 0){
				return text;
			}
			var obj:Object = ParseAttributes(xml);
			if(text){
				obj._text = text;
			}
			return obj;
		}
		
		static private function ParseAttributes(xml:XML):Object
		{
			var obj:Object = {};
			for each(var item:XML in xml.attributes()){
				obj[item.name().toString()] = item.toString();
			}
			return obj;
		}
	}
}