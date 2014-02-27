package flash.reflection.typeinfo
{
	public class VariableInfo extends PropInfo
	{
		public var type:String;
		private var access:String;
		
		public function VariableInfo(obj:Object)
		{
			super(obj);
		}
		
		override protected function parse(obj:Object):void
		{
			super.parse(obj);
			this.type = obj.type;
			this.access = obj.access;
		}
		
		public function canWrite():Boolean
		{
			return access != "readonly";
		}
	}
}