package snjdck.g2d.particlesystem
{
	import snjdck.gpu.BlendMode;
	import snjdck.gpu.GpuColor;
	
	import stdlib.constant.Unit;

	internal class ParticleSystemSetter
	{
		static public function Reset(ps:ParticleSystem, config:XML):void
		{
			var parser:ConfigParser = new ConfigParser(config);
			
//			ps.mEmitterX = parser.getNumber("sourcePosition", "x");
//			ps.mEmitterY = parser.getNumber("sourcePosition", "y");
			ps.mEmitterX = 0;
			ps.mEmitterY = 0;
			ps.mEmitterXVariance = parser.getNumber("sourcePositionVariance", "x");
			ps.mEmitterYVariance = parser.getNumber("sourcePositionVariance", "y");
			ps.mGravityX = parser.getNumber("gravity", "x");
			ps.mGravityY = parser.getNumber("gravity", "y");
			ps.mEmitterType = parser.getInt("emitterType");
			ps.mMaxNumParticles = parser.getInt("maxParticles");
			ps.mLifespan = Math.max(0.01, parser.getNumber("particleLifeSpan"));
			ps.mLifespanVariance = parser.getNumber("particleLifespanVariance");
			ps.mStartSize = parser.getNumber("startParticleSize");
			ps.mStartSizeVariance = parser.getNumber("startParticleSizeVariance");
			ps.mEndSize = parser.getNumber("finishParticleSize");
			ps.mEndSizeVariance = parser.getNumber("FinishParticleSizeVariance");
			ps.mEmitAngle = parser.getNumber("angle") * Unit.RADIAN;
			ps.mEmitAngleVariance = parser.getNumber("angleVariance") * Unit.RADIAN;
			ps.mStartRotation = parser.getNumber("rotationStart") * Unit.RADIAN;
			ps.mStartRotationVariance = parser.getNumber("rotationStartVariance") * Unit.RADIAN;
			ps.mEndRotation = parser.getNumber("rotationEnd") * Unit.RADIAN;
			ps.mEndRotationVariance = parser.getNumber("rotationEndVariance") * Unit.RADIAN;
			ps.mSpeed = parser.getNumber("speed");
			ps.mSpeedVariance = parser.getNumber("speedVariance");
			ps.mRadialAcceleration = parser.getNumber("radialAcceleration");
			ps.mRadialAccelerationVariance = parser.getNumber("radialAccelVariance");
			ps.mTangentialAcceleration = parser.getNumber("tangentialAcceleration");
			ps.mTangentialAccelerationVariance = parser.getNumber("tangentialAccelVariance");
			ps.mMaxRadius = parser.getNumber("maxRadius");
			ps.mMaxRadiusVariance = parser.getNumber("maxRadiusVariance");
			ps.mMinRadius = parser.getNumber("minRadius");
			ps.mMinRadiusVariance = parser.getNumber("minRadiusVariance");
			ps.mRotatePerSecond = parser.getNumber("rotatePerSecond") * Unit.RADIAN;
			ps.mRotatePerSecondVariance = parser.getNumber("rotatePerSecondVariance") * Unit.RADIAN;
			parser.getColor("startColor", ps.mStartColor);
			parser.getColor("startColorVariance", ps.mStartColorVariance);
			parser.getColor("finishColor", ps.mEndColor);
			parser.getColor("finishColorVariance", ps.mEndColorVariance);
			ps.blendMode = new BlendMode(
				parser.getBlendFactor("blendFuncSource"),
				parser.getBlendFactor("blendFuncDestination")
			);
			
			// compatibility with future Particle Designer versions
			// (might fix some of the uppercase/lowercase typos)
			
			if (isNaN(ps.mEndSizeVariance))
				ps.mEndSizeVariance = parser.getNumber("finishParticleSizeVariance");
			if (isNaN(ps.mLifespan))
				ps.mLifespan = Math.max(0.01, parser.getNumber("particleLifespan"));
			if (isNaN(ps.mLifespanVariance))
				ps.mLifespanVariance = parser.getNumber("particleLifeSpanVariance");
			if (isNaN(ps.mMinRadiusVariance))
				ps.mMinRadiusVariance = 0.0;
		}
		
		static public function InitParticle(ps:ParticleSystem, particle:Particle):void
		{
			var lifespan:Number = DeltaValue.Random(ps.mLifespan, ps.mLifespanVariance);
			
			particle.time = 0.0;
			particle.duration = lifespan > 0.0 ? lifespan : 0.0;
			
			if (lifespan <= 0.0) return;
			
			particle.startX = ps.mEmitterX;
			particle.startY = ps.mEmitterY;
			particle.x = DeltaValue.Random(ps.mEmitterX, ps.mEmitterXVariance);
			particle.y = DeltaValue.Random(ps.mEmitterY, ps.mEmitterYVariance);
			
			var angle:Number = DeltaValue.Random(ps.mEmitAngle, ps.mEmitAngleVariance);
			var speed:Number = DeltaValue.Random(ps.mSpeed, ps.mSpeedVariance);
			particle.velocityX = speed * Math.cos(angle);
			particle.velocityY = speed * Math.sin(angle);
			
			var startRadius:Number = DeltaValue.Random(ps.mMaxRadius, ps.mMaxRadiusVariance);
			var endRadius:Number   = DeltaValue.Random(ps.mMinRadius, ps.mMinRadiusVariance);
			particle.emitRadius = startRadius;
			particle.emitRadiusDelta = (endRadius - startRadius) / lifespan;
			particle.emitRotation = DeltaValue.Random(ps.mEmitAngle, ps.mEmitAngleVariance);
			particle.emitRotationDelta = DeltaValue.Random(ps.mRotatePerSecond, ps.mRotatePerSecondVariance);
			particle.radialAcceleration = DeltaValue.Random(ps.mRadialAcceleration, ps.mRadialAccelerationVariance);
			particle.tangentialAcceleration = DeltaValue.Random(ps.mTangentialAcceleration, ps.mTangentialAccelerationVariance);
			
			var startSize:Number = Math.max(0.1, DeltaValue.Random(ps.mStartSize, ps.mStartSizeVariance));
			var endSize:Number   = Math.max(0.1, DeltaValue.Random(ps.mEndSize, ps.mEndSizeVariance));
			particle.scale = startSize / ps.mTexture.width;
			particle.scaleDelta = ((endSize - startSize) / lifespan) / ps.mTexture.width;
			
			// colors
			var startColor:GpuColor = particle.color;
			var colorDelta:GpuColor = particle.colorDelta;
			
			SetColor(ps.mStartColor, ps.mStartColorVariance, startColor);
			SetColor(ps.mEndColor, ps.mEndColorVariance, colorDelta);
			
			colorDelta.red   = (colorDelta.red   - startColor.red)   / lifespan;
			colorDelta.green = (colorDelta.green - startColor.green) / lifespan;
			colorDelta.blue  = (colorDelta.blue  - startColor.blue)  / lifespan;
			colorDelta.alpha = (colorDelta.alpha - startColor.alpha) / lifespan;
			
			// rotation
			var startRotation:Number = DeltaValue.Random(ps.mStartRotation, ps.mStartRotationVariance); 
			var endRotation:Number   = DeltaValue.Random(ps.mEndRotation, ps.mEndRotationVariance); 
			
			particle.rotation = startRotation;
			particle.rotationDelta = (endRotation - startRotation) / lifespan;
		}
		
		static private function SetColor(value:GpuColor, delta:GpuColor, result:GpuColor):void
		{
			result.red   = DeltaValue.Random(value.red, delta.red);
			result.green = DeltaValue.Random(value.green, delta.green);
			result.blue  = DeltaValue.Random(value.blue, delta.blue);
			result.alpha = DeltaValue.Random(value.alpha, delta.alpha);
		}
	}
}