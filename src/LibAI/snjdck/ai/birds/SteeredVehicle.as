package snjdck.ai.birds
{
	import flash.geom.Vec2D;

	public class SteeredVehicle extends Vehicle
	{
		public var maxForce:Number = 1;
		public var arrivalThreshold:Number = 100;
		public var wanderDistance:Number = 10;
		public var wanderRadius:Number = 5;
		public var wanderRange:Number = 1;
		public var pathIndex:int = 0;
		public var pathThreshold:Number = 20;
		public var avoidDistance:Number = 300;
		public var avoidBuffer:Number = 20;
		public var inSightDist:Number = 200;
		public var tooCloseDist:Number = 60;
		
		private const _steeringForce:Vec2D = new Vec2D();
		private var _wanderAngle:Number = 0;
		
		public function SteeredVehicle(){}
		
		override public function update():void
		{
			_steeringForce.truncate(maxForce);
			_steeringForce.multiplyLocal(1 / mass);
			velocity.addLocal(_steeringForce);
			_steeringForce.setZero();
			super.update();
		}
		
		public function seek(target:Vec2D):void
		{
			var desiredVelocity:Vec2D = target.subtract(position);
			desiredVelocity.normalize();
			desiredVelocity = desiredVelocity.multiply(maxSpeed);
			var force:Vec2D = desiredVelocity.subtract(velocity);
			_steeringForce.addLocal(force);
		}
		
		public function flee(target:Vec2D):void
		{
			var desiredVelocity:Vec2D = target.subtract(position);
			desiredVelocity.normalize();
			desiredVelocity = desiredVelocity.multiply(maxSpeed);
			var force:Vec2D = desiredVelocity.subtract(velocity);
			_steeringForce.subtractLocal(force);
		}
		
		public function arrive(target:Vec2D):void
		{
			var desiredVelocity:Vec2D = target.subtract(position);
			desiredVelocity.normalize();
			
			var dist:Number = position.distance(target);
			if(dist > arrivalThreshold)
			{
				desiredVelocity = desiredVelocity.multiply(maxSpeed);
			}
			else
			{
				desiredVelocity = desiredVelocity.multiply(maxSpeed * dist / arrivalThreshold);
			}
			
			var force:Vec2D = desiredVelocity.subtract(velocity);
			_steeringForce.addLocal(force);
		}
		
		public function pursue(target:Vehicle):void
		{
			var lookAheadTime:Number = position.distance(target.position) / maxSpeed;
			var predictedTarget:Vec2D = target.position.add(target.velocity.multiply(lookAheadTime));
			seek(predictedTarget);
		}
		
		public function evade(target:Vehicle):void
		{
			var lookAheadTime:Number = position.distance(target.position) / maxSpeed;
			var predictedTarget:Vec2D = target.position.subtract(target.velocity.multiply(lookAheadTime));
			flee(predictedTarget);
		}
		
		public function wander():void
		{
			var center:Vec2D = velocity.clone();
			center.normalize();
			center.multiplyLocal(wanderDistance);
			var offset:Vec2D = new Vec2D();
			offset.length = wanderRadius;
			offset.angle = _wanderAngle;
			_wanderAngle += Math.random() * wanderRange - wanderRange * .5;
			var force:Vec2D = center.add(offset);
			_steeringForce.addLocal(force);
		}
		
		public function avoid(circles:Array):void
		{
		    for(var i:int = 0; i < circles.length; i++)
		    {
		        var circle:Circle = circles[i] as Circle;
		        var heading:Vec2D = velocity.clone();
				heading.normalize();
		        
		        // vector between circle and vehicle:
		        var difference:Vec2D = circle.position.subtract(position);
		        var dotProd:Number = difference.dotProd(heading);
		        
		        // if circle is in front of vehicle...
		        if(dotProd > 0)
		        {
		            // vector to represent "feeler" arm
		            var feeler:Vec2D = heading.multiply(avoidDistance);
		            // project difference vector onto feeler
		            var projection:Vec2D = heading.multiply(dotProd);
		            // distance from circle to feeler
		            var dist:Number = projection.subtract(difference).length;
		            
		            // if feeler intersects circle (plus buffer),
		            //and projection is less than feeler length,
		            // we will collide, so need to steer
		            if(dist < circle.radius + avoidBuffer &&
		               projection.length < feeler.length)
		            {
		                // calculate a force +/- 90 degrees from vector to circle
		                var force:Vec2D = heading.multiply(maxSpeed);
		                force.angle += difference.sign(velocity) * Math.PI / 2;
		                
		                // scale this force by distance to circle.
		                // the further away, the smaller the force
		                force = force.multiply(1.0 - projection.length /
		                                             feeler.length);
		                
		                // add to steering force
						_steeringForce.addLocal(force);
		                
		                // braking force
		                velocity.multiplyLocal(projection.length / feeler.length);
		            }
		        }
		    }
		}
		
		public function followPath(path:Array, loop:Boolean = false):void
		{
			var wayPoint:Vec2D = path[pathIndex];
			if(wayPoint == null) return;
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
		
		public function flock(vehicles:Array):void
		{
			var averageVelocity:Vec2D = velocity.clone();
			var averagePosition:Vec2D = new Vec2D();
			var inSightCount:int = 0;
			for(var i:int = 0; i < vehicles.length; i++)
			{
				var vehicle:Vehicle = vehicles[i] as Vehicle;
				if(vehicle != this && inSight(vehicle))
				{
					averageVelocity = averageVelocity.add(vehicle.velocity);
					averagePosition = averagePosition.add(vehicle.position);
					if(tooClose(vehicle)) flee(vehicle.position);
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
			if(position.distance(vehicle.position) > inSightDist) return false;
			var heading:Vec2D = velocity.clone();
			heading.normalize();
			var difference:Vec2D = vehicle.position.subtract(position);
			return difference.dotProd(heading) >= 0;
		}
		
		public function tooClose(vehicle:Vehicle):Boolean
		{
			return position.distance(vehicle.position) < tooCloseDist;
		}
	}
}