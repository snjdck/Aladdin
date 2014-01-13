package snjdck.game.vehicle
{
	import snjdck.common.geom.Vec2D;

	public class SteeredVehicle extends Vehicle
	{
		public var arrivalThreshold:Number = 100;
		public var wanderDistance:Number = 10;
		public var wanderRadius:Number = 5;
		public var wanderAngle:Number = 0;
		public var wanderRange:Number = 1;
		public var pathIndex:int = 0;
		public var pathThreshold:Number = 20;
		public var avoidDistance:Number = 300;
		public var avoidBuffer:Number = 20;
		public var inSightDistance:Number = 200;
		public var tooCloseDistance:Number = 60;
		
		public var maxForce:Number;
		private var _steeringForce:Vec2D;
		
		public function SteeredVehicle()
		{
			super();
			init();
		}
		
		private function init():void
		{
			maxForce = 1;
			_steeringForce = new Vec2D();
		}
		
		override public function update():void
		{
			_steeringForce.truncate(maxForce);
			_steeringForce = _steeringForce.divide(mass);
			velocity = velocity.add(_steeringForce);
			_steeringForce = new Vec2D();
			super.update();
		}
		
		//将机车移动到指定点
		public function seek(target:Vec2D):void
		{
			var dv:Vec2D = target.subtract(position);
			dv.normalize();
			dv = dv.multiply(maxSpeed);
			var force:Vec2D = dv.subtract(velocity);
			_steeringForce = _steeringForce.add(force);
		}
		
		public function flee(target:Vec2D):void
		{
			var dv:Vec2D = target.subtract(position);
			dv.normalize();
			dv = dv.multiply(maxSpeed);
			var force:Vec2D = dv.subtract(velocity);
			_steeringForce = _steeringForce.subtract(force);
		}
		
		public function arrive(target:Vec2D):void
		{
			var dv:Vec2D = target.subtract(position);
			dv.normalize();
			
			var d:Number = position.distance(target);
			
			if(d > arrivalThreshold)
				dv = dv.multiply(maxSpeed);
			else
				dv = dv.multiply(maxSpeed * d / arrivalThreshold);
			
			var force:Vec2D = dv.subtract(velocity);
			_steeringForce = _steeringForce.add(force);
		}
		
		public function pursue(target:Vehicle):void
		{
			var lookAheadTime:Number = position.distance(target.position) / maxSpeed;//以最大速度追上目标需要的时间
			var predictedTarget:Vec2D = target.position.add(target.velocity.multiply(lookAheadTime));//目标在这段时间内运动到的新位置
			this.seek(predictedTarget);
		}
		
		public function evade(target:Vehicle):void
		{
			var lookAheadTime:Number = position.distance(target.position) / maxSpeed;
			var predictedTarget:Vec2D = target.position.add(target.velocity.multiply(lookAheadTime));
			this.flee(predictedTarget);
		}
		
		public function wander():void
		{
			var center:Vec2D = velocity.normalize().multiply(wanderDistance);
			var offset:Vec2D = new Vec2D();
			offset.length = wanderRadius;
			offset.setAngle(wanderAngle);
			wanderAngle += wanderRange * (Math.random() - 0.5);
			var force:Vec2D = center.add(offset);
			_steeringForce = _steeringForce.add(force);
		}
		
		public function followPath(path:Array, loop:Boolean=false):void
		{
			var wayPoint:Vec2D = path[pathIndex];
			if(null == wayPoint)
				return;
			if(position.distance(wayPoint) < pathThreshold)
			{
				if(pathIndex >= path.length - 1)
				{
					if(loop)
					{
						pathIndex = 0;
					}
				}
				else
				{
					pathIndex++;
				}
			}
			if(pathIndex >= path.length - 1 && !loop)
			{
				arrive(wayPoint);
			}
			else
			{
				seek(wayPoint);
			}
		}
		
		//群落
		public function flock(vehicles:Array):void
		{
			var averageVelocity:Vec2D = velocity.clone();
			var averagePosition:Vec2D = new Vec2D();
			var inSightCount:int = 0;
			for(var i:int=0, n:int=vehicles.length; i<n; i++)
			{
				var vehicle:Vehicle = vehicles[i];
				if(vehicle != this && inSight(vehicle))
				{
					averageVelocity = averageVelocity.add(vehicle.velocity);
					averagePosition = averagePosition.add(vehicle.position);
					if(tooClose(vehicle))
						flee(vehicle.position);
					inSightCount++;
				}
			}
			if(inSightCount > 0)
			{
				averageVelocity = averageVelocity.divide(inSightCount);
				averagePosition = averagePosition.divide(inSightCount);
				seek(averagePosition);
				_steeringForce.add(averageVelocity.subtract(velocity));
			}
		}
		
		public function inSight(vehicle:Vehicle):Boolean		
		{
			if(position.distance(vehicle.position) > inSightDistance)
				return false;
			return velocity.clone().dotProd(vehicle.position.subtract(position)) >= 0;
			
		}
		
		public function tooClose(vehicle:Vehicle):Boolean
		{
			return position.distance(vehicle.position) < tooCloseDistance;
		}
	}
}