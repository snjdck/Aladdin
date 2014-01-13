package ui.list
{
	import ui.core.Component;
	
	public class ListItem extends Component
	{
		private var _isFocus:Boolean;
		protected var _data:*;
		
		public function ListItem()
		{
			super();
		}
		
		override public function get height():Number
		{
			return 22;
		}
		
		override public function get width():Number
		{
			return 100;
		}
		
		public function get data():*
		{
			return _data;
		}
		
		public function set data(value:Object):void
		{
			_data = value;
		}
		
		public function onFocusIn():void
		{
			_isFocus = true;
		}
		
		public function onFocusOut():void
		{
			_isFocus = false;
		}
		
		public function isFocus():Boolean
		{
			return _isFocus;
		}
	}
}