package snjdck.g2d.particlesystem
{
	import flash.geom.Matrix;
	
	import matrix33.toBuffer;
	
	import snjdck.g2d.render.Render2D;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.IGpuTexture;
	import snjdck.gpu.support.QuadBatchRender;

	final internal class ParticleRender extends QuadBatchRender
	{
		static public const Instance:ParticleRender = new ParticleRender();
		
		public function ParticleRender()
		{
			constData[14] = 0.5;
		}
		
		public function prepareVc(render:Render2D, worldMatrix:Matrix, texture:IGpuTexture):void
		{
			render.copyProjectData(constData);
			matrix33.toBuffer(worldMatrix, constData, 4);
			constData[12] = texture.width;
			constData[13] = texture.height;
		}
		
		public function drawParticles(context3d:GpuContext, particleList:Vector.<Particle>, numParticles:int):void
		{
			adjustData(numParticles);
			for(var i:int=0; i<numParticles; ++i)
			{
				var particle:Particle = particleList[i];
				var offset:int = i * data32perQuad;
				
				vertexData[offset+2] = vertexData[offset+12] = vertexData[offset+22] = vertexData[offset+32] = particle.x;
				vertexData[offset+3] = vertexData[offset+13] = vertexData[offset+23] = vertexData[offset+33] = particle.y;
				vertexData[offset+4] = vertexData[offset+14] = vertexData[offset+24] = vertexData[offset+34] = particle.scale;
				vertexData[offset+5] = vertexData[offset+15] = vertexData[offset+25] = vertexData[offset+35] = particle.rotation;
				
				vertexData[offset+6] = vertexData[offset+16] = vertexData[offset+26] = vertexData[offset+36] = particle.color.red;
				vertexData[offset+7] = vertexData[offset+17] = vertexData[offset+27] = vertexData[offset+37] = particle.color.green;
				vertexData[offset+8] = vertexData[offset+18] = vertexData[offset+28] = vertexData[offset+38] = particle.color.blue;
				vertexData[offset+9] = vertexData[offset+19] = vertexData[offset+29] = vertexData[offset+39] = particle.color.alpha;
			}
			draw(context3d, numParticles);
		}
	}
}