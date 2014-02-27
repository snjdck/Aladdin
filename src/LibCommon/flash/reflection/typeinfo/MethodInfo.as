package flash.reflection.typeinfo
{
	import array.getField;

	public class MethodInfo extends PropInfo
	{
		public var parameters:Array;
		private var returnType:String;
		
		public function MethodInfo(obj:Object)
		{
			super(obj);
		}
		
		override protected function parse(obj:Object):void
		{
			super.parse(obj);
			this.parameters = array.getField(obj.parameters, "type");
			this.returnType = obj.returnType;
		}
	}
}