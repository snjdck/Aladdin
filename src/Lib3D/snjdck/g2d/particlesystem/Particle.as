package snjdck.g2d.particlesystem
{
	import snjdck.gpu.GpuColor;

	final public class Particle
	{
		public var startX:Number;
		public var startY:Number;
		
		public var x:Number;
		public var y:Number;
		
		public var velocityX:Number;
		public var velocityY:Number;
		
		public var scale:Number;
		public var scaleDelta:Number;
		
		public var rotation:Number;
		public var rotationDelta:Number;
		
		public var emitRadius:Number;
		public var emitRadiusDelta:Number;
		
		public var emitRotation:Number;
		public var emitRotationDelta:Number;
		
		public var tangentialAcceleration:Number;
		public var radialAcceleration:Number;
		
		public var time:Number;
		public var duration:Number;
		
		public const color:GpuColor = new GpuColor();
		public const colorDelta:GpuColor = new GpuColor();
		
		public function Particle(){}
		
		public function updatePositionByGravity(gravityX:Number, gravityY:Number, passedTime:Number):void
		{
			var dx:Number = x - startX;
			var dy:Number = y - startY;
			
			var distanceScalar:Number = Math.sqrt(dx*dx + dy*dy);
			distanceScalar = (distanceScalar <= 0.01) ? 100 : (1 / distanceScalar);
			
			dx *= distanceScalar;
			dy *= distanceScalar;
			
			var radialX:Number = dx * radialAcceleration;
			var radialY:Number = dy * radialAcceleration;
			
			var tangentialX:Number = -dy * tangentialAcceleration;
			var tangentialY:Number =  dx * tangentialAcceleration;
			
			velocityX += passedTime * (gravityX + radialX + tangentialX);
			velocityY += passedTime * (gravityY + radialY + tangentialY);
			
			x += velocityX * passedTime;
			y += velocityY * passedTime;
		}
		
		public function updatePositionByRadial(emitterX:Number, emitterY:Number, passedTime:Number):void
		{
			emitRotation += emitRotationDelta * passedTime;
			emitRadius   += emitRadiusDelta   * passedTime;
			x = emitterX - Math.cos(emitRotation) * emitRadius;
			y = emitterY - Math.sin(emitRotation) * emitRadius;
		}
		
		public function onUpdate(passedTime:Number):void
		{
			if(time + passedTime < duration){
				time += passedTime;
			}else{
				time = duration;
			}
			
			scale	 += scaleDelta	  * passedTime;
			rotation += rotationDelta * passedTime;
			
			color.red	+= colorDelta.red	* passedTime;
			color.green += colorDelta.green * passedTime;
			color.blue	+= colorDelta.blue	* passedTime;
			color.alpha += colorDelta.alpha	* passedTime;
		}
	}
}