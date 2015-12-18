package
{
	import snjdck.ai.birds.SteeredVehicle;
	import com.foed.Vector2D;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Vec2D;

	public class SeekTest extends Sprite
	{
		private var _vehicle:SteeredVehicle;
		
		public function SeekTest()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			_vehicle = new SteeredVehicle();
			addChild(_vehicle);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(event:Event):void
		{
			_vehicle.seek(new Vec2D(mouseX, mouseY));
			_vehicle.update();
		}
	}
}