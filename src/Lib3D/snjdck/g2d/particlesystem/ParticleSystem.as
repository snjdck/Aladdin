package snjdck.g2d.particlesystem
{
	import snjdck.g2d.ns_g2d;
	import snjdck.g2d.impl.DisplayObject2D;
	import snjdck.g2d.render.Render2D;
	import snjdck.gpu.BlendMode;
	import snjdck.gpu.GpuColor;
	import snjdck.gpu.asset.AssetMgr;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuProgram;
	import snjdck.gpu.asset.IGpuTexture;
	import snjdck.gpu.support.QuadRender;
	import snjdck.shader.ShaderName;
	
	use namespace ns_g2d;
	
	public class ParticleSystem extends DisplayObject2D
	{
		static private const EMITTER_TYPE_GRAVITY:int = 0;
		static private const EMITTER_TYPE_RADIAL:int  = 1;
		
		internal var mTexture:IGpuTexture;
		internal var mParticles:Vector.<Particle>;
		internal var mFrameTime:Number;
		
		internal var mNumParticles:int;
		internal var mEmissionRate:Number; // emitted particles per second
		internal var mEmissionTime:Number;
		
		internal var blendMode:BlendMode;
		
		// emitter configuration                            // .pex element name
		internal var mEmitterType:int;                       // emitterType
		public var mEmitterX:Number;               		 // sourcePosition x
		public var mEmitterY:Number;               		 // sourcePosition y
		internal var mEmitterXVariance:Number;               // sourcePositionVariance x
		internal var mEmitterYVariance:Number;               // sourcePositionVariance y
		
		// particle configuration
		internal var mMaxNumParticles:int;                   // maxParticles
		internal var mLifespan:Number;                       // particleLifeSpan
		internal var mLifespanVariance:Number;               // particleLifeSpanVariance
		internal var mStartSize:Number;                      // startParticleSize
		internal var mStartSizeVariance:Number;              // startParticleSizeVariance
		internal var mEndSize:Number;                        // finishParticleSize
		internal var mEndSizeVariance:Number;                // finishParticleSizeVariance
		internal var mEmitAngle:Number;                      // angle
		internal var mEmitAngleVariance:Number;              // angleVariance
		internal var mStartRotation:Number;                  // rotationStart
		internal var mStartRotationVariance:Number;          // rotationStartVariance
		internal var mEndRotation:Number;                    // rotationEnd
		internal var mEndRotationVariance:Number;            // rotationEndVariance
		
		// gravity configuration
		internal var mSpeed:Number;                          // speed
		internal var mSpeedVariance:Number;                  // speedVariance
		internal var mGravityX:Number;                       // gravity x
		internal var mGravityY:Number;                       // gravity y
		internal var mRadialAcceleration:Number;             // radialAcceleration
		internal var mRadialAccelerationVariance:Number;     // radialAccelerationVariance
		internal var mTangentialAcceleration:Number;         // tangentialAcceleration
		internal var mTangentialAccelerationVariance:Number; // tangentialAccelerationVariance
		
		// radial configuration 
		internal var mMaxRadius:Number;                      // maxRadius
		internal var mMaxRadiusVariance:Number;              // maxRadiusVariance
		internal var mMinRadius:Number;                      // minRadius
		internal var mMinRadiusVariance:Number;              // minRadiusVariance
		internal var mRotatePerSecond:Number;                // rotatePerSecond
		internal var mRotatePerSecondVariance:Number;        // rotatePerSecondVariance
		
		// color configuration
		internal const mStartColor:GpuColor = new GpuColor();                  // startColor
		internal const mStartColorVariance:GpuColor = new GpuColor();          // startColorVariance
		internal const mEndColor:GpuColor = new GpuColor();                    // finishColor
		internal const mEndColorVariance:GpuColor = new GpuColor();            // finishColorVariance
		
		public function ParticleSystem(config:XML, texture:IGpuTexture)
		{
			ParticleSystemSetter.Reset(this, config);
			this.mTexture = texture;
			mEmissionRate = mMaxNumParticles / mLifespan;
			mParticles = new Vector.<Particle>();
			mEmissionTime = Number.MAX_VALUE;
			mFrameTime = 0;
		}
		
		private function advanceParticle(particle:Particle, passedTime:Number):void
		{
			if(mEmitterType == EMITTER_TYPE_RADIAL){
				particle.updatePositionByRadial(x, y, passedTime);
			}else{
				particle.updatePositionByGravity(mGravityX, mGravityY, passedTime);
			}
			particle.onUpdate(passedTime);
		}
		
		override protected function onDraw(render2d:Render2D, context3d:GpuContext):void
		{
//			const prevProgram:GpuProgram = context3d.program;
//			const prevBlendMode:BlendMode = context3d.blendMode;
			context3d.save();
			
			context3d.program = AssetMgr.Instance.getProgram(ShaderName.PARTICLE_2D);
			context3d.blendMode = blendMode;
			context3d.texture = mTexture;
			
			ParticleRender.Instance.prepareVc(render2d, prevWorldMatrix, mTexture);
			ParticleRender.Instance.drawParticles(context3d, mParticles, mNumParticles);
			
//			context3d.blendMode = prevBlendMode;
//			context3d.program = prevProgram;
			context3d.restore();
			QuadRender.Instance.drawBegin(context3d);
		}
		
		override public function onUpdate(timeElapsed:int):void
		{
			super.onUpdate(timeElapsed);
			const passedTime:Number = timeElapsed * 0.001;
			
			var particleIndex:int = 0;
			var particle:Particle;
			
			// advance existing particles
			
			while(particleIndex < mNumParticles)
			{
				particle = mParticles[particleIndex];
				if(particle.time < particle.duration){
					advanceParticle(particle, passedTime);
					++particleIndex;
				}else{
					--mNumParticles;
					if(particleIndex != mNumParticles){
						var nextParticle:Particle = mParticles[mNumParticles];
						mParticles[mNumParticles] = particle;
						mParticles[particleIndex] = nextParticle;
					}
					if (mNumParticles == 0 && mEmissionTime == 0){
						//dispatchEvent(new Event(Event.COMPLETE));
					}
				}
			}
			
			// create and advance new particles
			if(mEmissionTime <= 0){
				return;
			}
			
			var timeBetweenParticles:Number = 1.0 / mEmissionRate;
			mFrameTime += passedTime;
			
			while (mFrameTime > 0)
			{
				if (mNumParticles < mMaxNumParticles)
				{
					if(mParticles.length <= mNumParticles){
						mParticles.push(new Particle());
					}
					
					particle = mParticles[mNumParticles];
					ParticleSystemSetter.InitParticle(this, particle);
					
					// particle might be dead at birth
					if (particle.duration > 0){
						advanceParticle(particle, mFrameTime);
						++mNumParticles;
					}
				}
				
				mFrameTime -= timeBetweenParticles;
			}
			
			if (mEmissionTime != Number.MAX_VALUE){
				mEmissionTime = Math.max(0.0, mEmissionTime - passedTime);
			}
		}
	}
}