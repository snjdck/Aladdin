package snjdck.gpu
{
	import flash.display.Sprite;
	
	public class App3D extends Sprite
	{
		static public var app:App3D;
		
		public var view3d:View3D;
		
		public function App3D()
		{
			app = this;
			
			view3d = new View3D(stage);
		}
	}
}