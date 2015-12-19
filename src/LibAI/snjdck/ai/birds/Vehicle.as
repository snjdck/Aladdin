package snjdck.ai.birds
{
	import flash.display.Sprite;
	import flash.geom.Vec2D;
	
	import stdlib.constant.Unit;
	
	public class Vehicle extends Sprite
	{
		public static const WRAP:String = "wrap";
		public static const BOUNCE:String = "bounce";
		
		public var edgeBehavior:String = WRAP;
		public var mass:Number = 1.0;
		public var maxSpeed:Number = 10;
		private const _position:Vec2D = new Vec2D();
		public const velocity:Vec2D = new Vec2D();
		
		public function Vehicle()
		{
			draw();
		}
		
		protected function draw():void
		{
			graphics.clear();
			graphics.lineStyle(0);
			graphics.moveTo(10, 0);
			graphics.lineTo(-10, 5);
			graphics.lineTo(-10, -5);
			graphics.lineTo(10, 0);
		}
		
		public function update():void
		{
			velocity.truncate(maxSpeed);
			_position.addLocal(velocity);
			
			if(edgeBehavior == WRAP)		wrap();
			else if(edgeBehavior == BOUNCE)	bounce();
			
			super.x = position.x;
			super.y = position.y;
			rotation = velocity.angle * Unit.DEGREE;
		}
		
		private function bounce():void
		{
			if(stage == null){
				return;
			}
			if(position.x > stage.stageWidth){
				position.x = stage.stageWidth;
				velocity.x *= -1;
			}else if(position.x < 0){
				position.x = 0;
				velocity.x *= -1;
			}
			if(position.y > stage.stageHeight){
				position.y = stage.stageHeight;
				velocity.y *= -1;
			}else if(position.y < 0){
				position.y = 0;
				velocity.y *= -1;
			}
		}
		
		private function wrap():void
		{
			if(stage == null){
				return;
			}
			if(position.x > stage.stageWidth) position.x = 0;
			if(position.x < 0) position.x = stage.stageWidth;
			if(position.y > stage.stageHeight) position.y = 0;
			if(position.y < 0) position.y = stage.stageHeight;
		}
		
		public function set position(value:Vec2D):void
		{
			_position.setTo(value.x, value.y);
			super.x = _position.x;
			super.y = _position.y;
		}
		
		public function get position():Vec2D
		{
			return _position;
		}
		
		override public function set x(value:Number):void
		{
			super.x = value;
			position.x = value;
		}
		
		override public function set y(value:Number):void
		{
			super.y = value;
			position.y = value;
		}
	}
}