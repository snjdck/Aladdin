package snjdck.g2d.text
{
	import flash.geom.Matrix;
	
	import matrix33.toBuffer;
	
	import snjdck.g2d.render.Render2D;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.support.QuadBatchRender;

	public class TextRender extends QuadBatchRender
	{
		static public const Instance:TextRender = new TextRender();
		
		private const textFactory:TextFactory = new TextFactory();
		private const charList:CharInfoList = new CharInfoList();
		
		public function TextRender()
		{
			constData[14] = 0.5;
		}
		
		public function prepareVc(render:Render2D, worldMatrix:Matrix):void
		{
			render.copyProjectData(constData);
			matrix33.toBuffer(worldMatrix, constData, 4);
		}
		
		public function drawText(context3d:GpuContext, text:String, maxWidth:int, maxHeight:int):void
		{
			textFactory.getCharList(text, charList);
			charList.arrange(maxWidth, maxHeight);
			
			var quadCount:int = charList.charCount;
			
			updateVertexData(quadCount);
			charList.clear();
			
			context3d.texture = textFactory.gpuTexture;
			
			constData[12] = textFactory.gpuTexture.width;
			constData[13] = textFactory.gpuTexture.height;
			draw(context3d, quadCount);
		}
		
		private function updateVertexData(quadCount:int):void
		{
			adjustData(quadCount);
			for(var i:int=0; i<quadCount; ++i)
			{
				var charInfo:CharInfo = charList.getCharAt(i);
				var offset:int = i * data32perQuad;
				
				vertexData[offset+2] = vertexData[offset+12] = vertexData[offset+22] = vertexData[offset+32] = charInfo.x;
				vertexData[offset+3] = vertexData[offset+13] = vertexData[offset+23] = vertexData[offset+33] = charInfo.y;
				vertexData[offset+4] = vertexData[offset+14] = vertexData[offset+24] = vertexData[offset+34] = charInfo.uvX;
				vertexData[offset+5] = vertexData[offset+15] = vertexData[offset+25] = vertexData[offset+35] = charInfo.uvY;
				
				vertexData[offset+6] = vertexData[offset+16] = vertexData[offset+26] = vertexData[offset+36] = charInfo.width;
				vertexData[offset+7] = vertexData[offset+17] = vertexData[offset+27] = vertexData[offset+37] = charInfo.height;
				vertexData[offset+8] = vertexData[offset+18] = vertexData[offset+28] = vertexData[offset+38] = 2;
				vertexData[offset+9] = vertexData[offset+19] = vertexData[offset+29] = vertexData[offset+39] = 0;
			}
		}
	}
}