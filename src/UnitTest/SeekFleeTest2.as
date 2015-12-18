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

	public class SeekFleeTest2 extends Sprite
	{
		private var _vehicleA:SteeredVehicle;
		private var _vehicleB:SteeredVehicle;
		private var _vehicleC:SteeredVehicle;
		
		public function SeekFleeTest2()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			_vehicleA = new SteeredVehicle();
			_vehicleA.position = new Vec2D(200, 200);
			_vehicleA.edgeBehavior = Vehicle.BOUNCE;
			addChild(_vehicleA);
			
			_vehicleB = new SteeredVehicle();
			_vehicleB.position = new Vec2D(400, 200);
			_vehicleB.edgeBehavior = Vehicle.BOUNCE;
			addChild(_vehicleB);
			
			_vehicleC = new SteeredVehicle();
			_vehicleC.position = new Vec2D(300, 260);
			_vehicleC.edgeBehavior = Vehicle.BOUNCE;
			addChild(_vehicleC);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(event:Event):void
		{
			_vehicleA.seek(_vehicleB.position);
			_vehicleA.flee(_vehicleC.position);
			
			_vehicleB.seek(_vehicleC.position);
			_vehicleB.flee(_vehicleA.position);
			
			_vehicleC.seek(_vehicleA.position);
			_vehicleC.flee(_vehicleB.position);
			
			_vehicleA.update();
			_vehicleB.update();
			_vehicleC.update();
		}
	}
}