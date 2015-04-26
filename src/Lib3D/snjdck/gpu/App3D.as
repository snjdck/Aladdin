package snjdck.gpu
{
	import flash.display.Sprite;
	
	import snjdck.clock.Clock;
	import snjdck.clock.ITicker;
	

	public class App3D extends Sprite implements ITicker
	{
		static public var app:App3D;
		
		public var view3d:View3D;
		public var input:Input;
		
		public function App3D()
		{
			app = this;
			
			view3d = new View3D(stage);
			input = new Input(stage);
			
			Clock.getInstance().add(this);
		}
		
		public function onTick(timeElapsed:int):void
		{
			input.onTick(timeElapsed);
			view3d.onTick(timeElapsed);
		}
	}
}