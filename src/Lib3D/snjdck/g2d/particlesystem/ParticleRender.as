package snjdck.g2d.particlesystem
{
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Matrix;
	
	import matrix33.toBuffer;
	
	import snjdck.g2d.render.Render2D;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuIndexBuffer;
	import snjdck.gpu.asset.GpuVertexBuffer;
	import snjdck.gpu.asset.IGpuTexture;

	final internal class ParticleRender
	{
		static public const data32perVertex:int = 10;
		static public const data32perQuad:int = 4 * data32perVertex;
		
		static public const Instance:ParticleRender = new ParticleRender();
		
		private var vertexBuffer:GpuVertexBuffer;
		private const vertexData:Vector.<Number> = new Vector.<Number>();
		
		private var indexBuffer:GpuIndexBuffer;
		private const indexData:Vector.<uint> = new Vector.<uint>();
		
		private const constData:Vector.<Number> = new Vector.<Number>(16, true);
		private var maxQuadCount:int;
		
		public function ParticleRender()
		{
			constData[14] = 0.5;
			constData[15] = 0;
		}
		
		public function prepareVc(render:Render2D, worldMatrix:Matrix, texture:IGpuTexture):void
		{
			render.copyWorldProjectData(constData);
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
		
		private function draw(context3d:GpuContext, quadCount:int):void
		{
			context3d.setVc(0, constData, 4);
			vertexBuffer.upload(vertexData, quadCount << 2);
			context3d.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			context3d.setVertexBufferAt(1, vertexBuffer, 2, Context3DVertexBufferFormat.FLOAT_4);
			context3d.setVertexBufferAt(2, vertexBuffer, 6, Context3DVertexBufferFormat.FLOAT_4);
			context3d.drawTriangles(indexBuffer, 0, quadCount << 1);
		}
		
		private function adjustData(quadCount:int):void
		{
			if(maxQuadCount < quadCount)
			{
				adjustVertexData(quadCount);
				adjustIndexData(quadCount);
				if(vertexBuffer != null){
					vertexBuffer.dispose();
				}
				vertexBuffer = new GpuVertexBuffer(quadCount << 2, data32perVertex, true);
				if(indexBuffer != null){
					indexBuffer.dispose();
				}
				indexBuffer = new GpuIndexBuffer(indexData.length);
				indexBuffer.upload(indexData);
				maxQuadCount = quadCount;
			}
		}
		
		private function adjustVertexData(quadCount:int):void
		{
			vertexData.length = quadCount * data32perQuad;
			for(var i:int=maxQuadCount; i<quadCount; ++i){
				var offset:int = i * data32perQuad;
//				vertexData[offset   ] = vertexData[offset+1 ] = vertexData[offset+11] = vertexData[offset+20] = 0;
				vertexData[offset+10] = vertexData[offset+21] = vertexData[offset+30] = vertexData[offset+31] = 1;
			}
		}
		
		private function adjustIndexData(quadCount:int):void
		{
			var offset:int = indexData.length;
			indexData.length = quadCount * 6;
			for(var i:int=maxQuadCount; i<quadCount; ++i){
				var index:int = i << 2;
				indexData[offset++] = index;
				indexData[offset++] = index + 1;
				indexData[offset++] = index + 3;
				indexData[offset++] = index;
				indexData[offset++] = index + 3;
				indexData[offset++] = index + 2;
			}
		}
	}
}