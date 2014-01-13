package htmlui.layout
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	public class BorderLayout extends Layout
	{
		static public const NORTH	:String = "north";
		static public const SOUTH	:String = "south";
		static public const WEST	:String = "west";
		static public const EASE	:String = "east";
		static public const CENTER	:String = "center";
		
		public function BorderLayout(target:DisplayObjectContainer)
		{
			super(target);
		}
		
		override protected function relayout():void
		{
			var child:DisplayObject;
		}
	}
}