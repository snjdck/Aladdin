package htmlui
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import snjdck.signal.ISignal;
	import snjdck.signal.Signal;
	
	public class UIObject extends Sprite implements IUIObject
	{
		private var signal:Signal = new Signal(Point);
		
		public var margin:Object;
		public var border:Object;
		public var padding:Object
		
		public function UIObject()
		{
			super();
		}
		
		public function get viewAreaChangeSignal():snjdck.signal.ISignal
		{
			return signal;
		}
		
		override public function set x(value:Number):void
		{
			super.x = value;
			signal.notify();
		}
		
		override public function set y(value:Number):void
		{
			super.y = value;
			signal.notify();
		}
		
		override public function set width(value:Number):void
		{
			super.width = value;
			signal.notify();
		}
		
		override public function set height(value:Number):void
		{
			super.height = value;
			signal.notify();
		}
	}
}