package
{
	import snjdck.ai.birds.SteeredVehicle;
	import com.foed.Vector2D;
	import snjdck.ai.birds.Vehicle;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Vec2D;

	public class FlockTest extends Sprite
	{
		private var _vehicles:Array;
		private var _numVehicles:int = 30;
		
		public function FlockTest()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			_vehicles = new Array();
			for(var i:int = 0; i < _numVehicles; i++)
			{
				var vehicle:SteeredVehicle = new SteeredVehicle();
				vehicle.position = new Vec2D(Math.random() * stage.stageWidth, Math.random() * stage.stageHeight);
				vehicle.velocity.setTo(Math.random() * 20 - 10, Math.random() * 20 - 10);
				vehicle.edgeBehavior = Vehicle.BOUNCE;
				_vehicles.push(vehicle);
				addChild(vehicle);
			}
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(event:Event):void
		{
			var vehicle:SteeredVehicle;
			var i:int;
			for(i = 0; i < _numVehicles; i++)
			{
				vehicle = _vehicles[i];
				vehicle.flock(_vehicles);
			}
			for(i = 0; i < _numVehicles; i++)
			{
				vehicle = _vehicles[i];
				vehicle.update();
			}
		}
	}
}