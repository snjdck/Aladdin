package
{
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class AgalTest extends Sprite
	{
		[Embed(source="test4.agal", mimeType="application/octet-stream")]
		public var BIN:Class;
		
		private var context3d:Context3D;
		private var program:ProgramReader;
		
		private var obj:TestObj;
		
		public function AgalTest()
		{
			stage.stage3Ds[0].addEventListener(Event.CONTEXT3D_CREATE, __onCreate);
			stage.stage3Ds[0].requestContext3D();
			program = new ProgramReader(new BIN())
		}
		
		private function __onCreate(evt:Event):void
		{
			stage.addEventListener(Event.ENTER_FRAME, __onUpdate);
			
			var stage3d:Stage3D = evt.target as Stage3D;
			context3d = stage3d.context3D;
			context3d.enableErrorChecking = true;
			
			program.createGpuProgram(context3d);
			context3d.configureBackBuffer(stage.stageWidth, stage.stageHeight, 0, false);
			
			obj = new TestObj(context3d);
			obj.program = program;
		}
		
		private function __onUpdate(evt:Event):void
		{
			context3d.clear(1);
			obj.draw(context3d);
			context3d.present();
		}
	}
}