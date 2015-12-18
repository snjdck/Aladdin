package
{
	import snjdck.ai.birds.SteeredVehicle;
	import snjdck.ai.birds.Vehicle;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Vec2D;

	public class FleeTest extends Sprite
	{
		private var _vehicle:SteeredVehicle;
		
		public function FleeTest()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			_vehicle = new SteeredVehicle();
			_vehicle.position = new Vec2D(200, 200);
			_vehicle.edgeBehavior = Vehicle.BOUNCE;
			addChild(_vehicle);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(event:Event):void
		{
			_vehicle.flee(new Vec2D(mouseX, mouseY));
			_vehicle.update();
		}
	}
}