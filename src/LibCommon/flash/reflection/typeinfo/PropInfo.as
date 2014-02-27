package flash.reflection.typeinfo
{
	internal class PropInfo
	{
		private var metadata:Object;
		public var name:String;
		
		public function PropInfo(obj:Object)
		{
			parse(obj);
		}
		
		protected function parse(obj:Object):void
		{
			this.metadata = createMetadata(obj.metadata);
			this.name = obj.name;
		}
		
		public function hasMetaTag(tagName:String):Boolean
		{
			return metadata && (tagName in metadata);
		}
		
		public function getMetaTagValue(tagName:String):Object
		{
			return metadata[tagName];
		}
		
		private function createMetadata(source:Object):Object
		{
			if(null == source){
				return null;
			}
			var metaTagDict:Object = {};
			for each(var metaTag:Object in source){
				metaTagDict[metaTag.name] = createMetaTagArgs(metaTag.value);
			}
			return metaTagDict;
		}
		
		private function createMetaTagArgs(source:Array):Object
		{
			var metaTagArgs:Object = {};
			var index:int = 0;
			
			for each(var item:Object in source)
			{
				const key:String = item.key;
				const val:Object = item.value;
				if(false == Boolean(key)){
					metaTagArgs[index++] = val;
					continue;
				}
				if(false == (key in metaTagArgs)){
					metaTagArgs[key] = val;
					continue;
				}
				if(metaTagArgs[key] is Array){
					metaTagArgs[key].push(val);
				}else{
					metaTagArgs[key] = [metaTagArgs[key], val];
				}
			}
			
			return metaTagArgs;
		}
	}
}