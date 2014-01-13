package snjdck.game.vehicle
{
	import flash.display.Sprite;
	
	import snjdck.common.geom.Vec2D;
	
	
	public class Vehicle extends Sprite
	{
		public var mass:Number;			//质量
		public var maxSpeed:Number;		//最大速度
		private var _position:Vec2D;	//位置
		private var _velocity:Vec2D;	//速度
		
		public function Vehicle()
		{
			super();
			init();
		}
		
		private function init():void
		{
			this.mass = 1;
			this.maxSpeed = 10;
			this._position = new Vec2D();
			this._velocity = new Vec2D();
			//
			draw();
		}
		
		//getter and setter
		
		public function get position():Vec2D
		{
			return this._position;
		}
		
		public function set position(value:Vec2D):void
		{
			this._position = value;
			updateLocation();
		}
		
		public function get velocity():Vec2D
		{
			return this._velocity;
		}
		
		public function set velocity(value:Vec2D):void
		{
			this._velocity = value;
		}
		
		protected function draw():void
		{
			with(this.graphics)
			{
				clear();
				lineStyle(0);
				moveTo(10, 0);
				lineTo(-10, 5);
				lineTo(-10, -5);
				lineTo(10, 0);
			}
		}
		
		public function update():void
		{
			//保证速度不超过最大速度
			_velocity.truncate(maxSpeed);
			//更新位置
			_position = _position.add(_velocity);
			
			wrap();
			
			//更新屏幕位置
			updateLocation();
			this.rotation = 180 * _velocity.getAngle() / Math.PI;
		}
		
		private function updateLocation():void
		{
			this.x = _position.x;
			this.y = _position.y;
		}
		
		private function wrap():void
		{
			if(null != stage)
			{
				if(position.x < 0)
					position.x = stage.stageWidth;
				else if(position.x > stage.stageWidth)
					position.x = 0;
				
				if(position.y < 0)
					position.y = stage.stageHeight;
				else if(position.y > stage.stageHeight)
					position.y = 0;
			}
		}
		
		private function bounce():void
		{
			if(null != stage)
			{
				if(position.x > stage.stageWidth)
				{
					position.x = stage.stageWidth;
					velocity.x *= -1;
				}
				else if(position.x < 0)
				{
					position.x = 0;
					velocity.x *= -1;
				}
				
				if(position.y > stage.stageHeight)
				{
					position.y = stage.stageHeight;
					velocity.y *= -1;
				}
				else if(position.y < 0)
				{
					position.y = 0;
					velocity.y *= -1;
				}
			}
		}
		
		override public function set x(value:Number):void
		{
			super.x = position.x = value;
		}
		
		override public function set y(value:Number):void
		{
			super.y = position.y = value;
		}
	}
}