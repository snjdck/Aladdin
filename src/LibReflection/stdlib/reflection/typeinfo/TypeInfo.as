package stdlib.reflection.typeinfo
{
	import array.getField;

	public class TypeInfo extends PropInfo
	{
		public const variables:Object = {};
		public const methods:Object = {};
		public var ctor:Array;
		private var bases:Array;
		private var interfaces:Array;
		
		public function TypeInfo(obj:Object)
		{
			super(obj);
		}
		
		override protected function parse(obj:Object):void
		{
			super.parse(obj.traits);
			this.name = obj.name;
			this.bases = obj.traits.bases;
			this.interfaces = obj.traits.interfaces;
			this.ctor = array.getField(obj.traits.constructor, "type");
			parseImp(obj.traits.accessors, variables, VariableInfo);
			parseImp(obj.traits.variables, variables, VariableInfo);
			parseImp(obj.traits.methods, methods, MethodInfo);
		}
		
		static private function parseImp(list:Array, dict:Object, cls:Class):void
		{
			for each(var item:Object in list){
				var propInfo:PropInfo = new cls(item);
				dict[propInfo.name] = propInfo;
			}
		}
	}
}