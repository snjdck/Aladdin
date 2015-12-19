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
		
		private const steeringForce:Vec2D = new Vec2D();
		private var wanderAngle:Number = 0;
		
		public function SteeredVehicle(){}
		
		override public function update():void
		{
			steeringForce.truncate(maxForce);
			steeringForce.multiplyLocal(1 / mass);
			velocity.addLocal(steeringForce);
			steeringForce.setZero();
			super.update();
		}
		
		private function getSeekSteerForce(target:Vec2D):Vec2D
		{
			var desiredVelocity:Vec2D = target.subtract(position);
			desiredVelocity.normalize();
			desiredVelocity.multiplyLocal(maxSpeed);
			desiredVelocity.subtractLocal(velocity);
			return desiredVelocity;
		}
		
		public function seek(target:Vec2D):void
		{
			steeringForce.addLocal(getSeekSteerForce(target));
		}
		
		public function flee(target:Vec2D):void
		{
			steeringForce.subtractLocal(getSeekSteerForce(target));
		}
		
		public function arrive(target:Vec2D):void
		{
			var desiredVelocity:Vec2D = target.subtract(position);
			desiredVelocity.normalize();
			
			var dist:Number = position.distance(target);
			if(dist > arrivalThreshold){
				desiredVelocity.multiplyLocal(maxSpeed);
			}else{
				desiredVelocity.multiplyLocal(maxSpeed * dist / arrivalThreshold);
			}
			desiredVelocity.subtractLocal(velocity);
			steeringForce.addLocal(desiredVelocity);
		}
		
		private function getLookAheadOffset(target:Vehicle):Vec2D
		{
			var lookAheadTime:Number = position.distance(target.position) / maxSpeed;
			return target.velocity.multiply(lookAheadTime);
		}
		
		public function pursue(target:Vehicle):void
		{
			seek(target.position.add(getLookAheadOffset(target)));
		}
		
		public function evade(target:Vehicle):void
		{
			flee(target.position.subtract(getLookAheadOffset(target)));
		}
		
		public function wander():void
		{
			var center:Vec2D = velocity.clone();
			center.normalize();
			center.multiplyLocal(wanderDistance);
			var offset:Vec2D = new Vec2D();
			offset.length = wanderRadius;
			offset.angle = wanderAngle;
			wanderAngle += wanderRange * (Math.random() - 0.5);
			var force:Vec2D = center.add(offset);
			steeringForce.addLocal(force);
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
						steeringForce.addLocal(force);
		                
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
			if(position.distanceInside(wayPoint, pathThreshold)){
				if(pathIndex >= path.length - 1){
					if(loop){
						pathIndex = 0;
					}
				}else{
					pathIndex++;
				}
			}
			if(loop || pathIndex < path.length - 1){
				seek(wayPoint);
			}else{
				arrive(wayPoint);
			}
		}
		
		static private const averagePosition:Vec2D = new Vec2D();
		
		public function flock(vehicles:Array):void
		{
			averagePosition.setZero();
			var inSightCount:int = 0;
			for(var i:int=vehicles.length-1; i >= 0; --i){
				var vehicle:Vehicle = vehicles[i];
				if(vehicle != this && inSight(vehicle)){
					averagePosition.addLocal(vehicle.position);
					++inSightCount;
					if(tooClose(vehicle))
						flee(vehicle.position);
				}
			}
			if(inSightCount > 0){
				averagePosition.multiplyLocal(1 / inSightCount);
				seek(averagePosition);
			}
		}
		
		public function inSight(vehicle:Vehicle):Boolean
		{
			if(position.distanceOutside(vehicle.position, inSightDist))
				return false;
			var heading:Vec2D = velocity.clone();
			heading.normalize();
			var difference:Vec2D = vehicle.position.subtract(position);
			return difference.dotProd(heading) >= 0;
		}
		
		public function tooClose(vehicle:Vehicle):Boolean
		{
			return position.distanceInside(vehicle.position, tooCloseDist);
		}
	}
}