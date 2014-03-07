package ui.text
{
	import flash.text.TextFieldType;
	
	public class TextInput extends TextComponent
	{
		public function TextInput()
		{
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			labelTf.type = TextFieldType.INPUT;
		}
		
		public function get restrict():String
		{
			return labelTf.restrict;
		}
		
		public function set restrict(value:String):void
		{
			labelTf.restrict = value;
		}
		
		public function get displayAsPassword():Boolean
		{
			return labelTf.displayAsPassword;
		}
		
		public function set displayAsPassword(value:Boolean):void
		{
			labelTf.displayAsPassword = value;
		}
		
		public function get maxChars():int
		{
			return labelTf.maxChars;
		}
		
		public function set maxChars(value:int):void
		{
			labelTf.maxChars = value;
		}
	}
}