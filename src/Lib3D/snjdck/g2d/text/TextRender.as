package snjdck.g2d.text
{
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Matrix;
	
	import matrix33.toBuffer;
	
	import snjdck.g2d.particlesystem.Particle;
	import snjdck.g2d.render.Render2D;
	import snjdck.g2d.text.drawer.TextDrawer;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuIndexBuffer;
	import snjdck.gpu.asset.GpuVertexBuffer;
	import snjdck.gpu.asset.IGpuTexture;
	
	public class TextRender
	{
		static public const Instance:TextRender = new TextRender();
		
		private const data32perVertex:int = 3;
		private const data32perQuad:int = data32perVertex << 2;
		
		private var vertexBuffer:GpuVertexBuffer;
		private const vertexData:Vector.<Number> = new Vector.<Number>();
		
		private var indexBuffer:GpuIndexBuffer;
		private const indexData:Vector.<uint> = new Vector.<uint>();
		
		private var maxQuadCount:int;
		
		private const constData:Vector.<Number> = new Vector.<Number>(1000, true);
		
		public function TextRender(){}
		
		protected function adjustData(quadCount:int):void
		{
			if(maxQuadCount >= quadCount){
				return;
			}
			
			adjustVertexData(quadCount);
			adjustIndexData(quadCount);
			
			maxQuadCount = quadCount;
			
			if(vertexBuffer != null){
				vertexBuffer.dispose();
			}
			if(indexBuffer != null){
				indexBuffer.dispose();
			}
			
			vertexBuffer = new GpuVertexBuffer(quadCount << 2, data32perVertex);
			vertexBuffer.upload(vertexData, quadCount << 2);
			
			indexBuffer = new GpuIndexBuffer(indexData.length);
			indexBuffer.upload(indexData);
		}
		
		private function adjustVertexData(quadCount:int):void
		{
			vertexData.length = quadCount * data32perQuad;
			var offset:int = maxQuadCount * data32perQuad;
			for(var i:int=maxQuadCount; i<quadCount; ++i){
				vertexData[offset+2] = i;
				offset += data32perVertex;
				vertexData[offset] = 1;
				vertexData[offset+2] = i;
				offset += data32perVertex;
				vertexData[offset+1] = 1;
				vertexData[offset+2] = i;
				offset += data32perVertex;
				vertexData[offset] = 1;
				vertexData[offset+1] = 1;
				vertexData[offset+2] = i;
				offset += data32perVertex;
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
		
		public function prepareVc(render:Render2D, worldMatrix:Matrix):void
		{
			render.copyProjectData(constData);
			matrix33.toBuffer(worldMatrix, constData, 4);
		}
		
		public function drawText(context3d:GpuContext, charList:CharInfoList, fontSize:int):void
		{
			constData[12] = fontSize;
			constData[13] = TextDrawer.FontSize / TextFactory.TextureSize;
			constData[14] = 0;
			constData[15] = 1;
			
			var nn:int = 124;
			var quadCount:int = charList.charCount;
			var batchCount:int = Math.ceil(quadCount / nn);
			
			adjustData(Math.min(quadCount, nn));
			context3d.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			
			for(var i:int=0; i<batchCount; ++i){
				var fromIndex:int = i * nn;
				var count:int = Math.min(nn, quadCount - fromIndex);
				setTextData(charList, fromIndex, count);
				context3d.setVc(0, constData, 4+count);
				context3d.drawTriangles(indexBuffer, 0, count << 1);
			}
		}
		
		public function drawParticles(context3d:GpuContext, particleList:Vector.<Particle>, numParticles:int, texture:IGpuTexture):void
		{
			constData[12] = texture.width;
			constData[13] = texture.height;
			constData[14] = 0.5;
			constData[15] = 0;
			
			var nn:int = 62;
//			var nn:int = 123;
			var quadCount:int = numParticles;
			var batchCount:int = Math.ceil(quadCount / nn);
			
			adjustData(Math.min(quadCount, nn));
			context3d.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			
			for(var i:int=0; i<batchCount; ++i){
				var fromIndex:int = i * nn;
				var count:int = Math.min(nn, quadCount - fromIndex);
				setParticleData(particleList, fromIndex, count);
				context3d.setVc(0, constData, 4+count*2);
				context3d.drawTriangles(indexBuffer, 0, count << 1);
			}
		}
		
		private function setTextData(charList:CharInfoList, fromIndex:int, count:int):void
		{
			var offset:int = 16;
			for(var i:int=0; i<count; ++i){
				var charInfo:CharInfo = charList.getCharAt(fromIndex+i);
				constData[offset++] = charInfo.x;
				constData[offset++] = charInfo.y;
				constData[offset++] = charInfo.uvX;
				constData[offset++] = charInfo.uvY;
			}
		}
		
		private function setParticleData(particleList:Vector.<Particle>, fromIndex:int, count:int):void
		{
			var offset:int = 16;
			for(var i:int=0; i<count; ++i){
				var particle:Particle = particleList[fromIndex+i];
				constData[offset++] = particle.x;
				constData[offset++] = particle.y;
				constData[offset++] = particle.scale;
				constData[offset++] = particle.rotation;
				constData[offset++] = particle.color.red;
				constData[offset++] = particle.color.green;
				constData[offset++] = particle.color.blue;
				constData[offset++] = particle.color.alpha;
			}
		}
	}
}