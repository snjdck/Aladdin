package snjdck.g2d.render
{
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;

	final internal class ConstData
	{
		private var rawData:Vector.<Number>;
		
		public function ConstData(data:Vector.<Number>)
		{
			rawData = data;
		}
		
		public function resetWorldMatrix():void
		{
			rawData[4] = rawData[9] = 1;
			rawData[5] = rawData[6] = rawData[7] = rawData[8] = rawData[10] = rawData[11] = 0;
		}
		
		public function resetFrameMatrix():void
		{
			rawData[12] = rawData[13] = 1;
			rawData[16] = rawData[17] = 0;
		}
		
		public function resetUvMatrix():void
		{
			rawData[14] = rawData[15] = 1;
			rawData[18] = rawData[19] = 0;
		}
		
		public function resetScale9():void
		{
			rawData[24] = rawData[25] = rawData[26] = rawData[27] = 0;
		}
		
		public function setRect(x:Number, y:Number, width:Number, height:Number):void
		{
			rawData[16] = x;
			rawData[17] = y;
			rawData[20] = rawData[21] = width;
			rawData[22] = rawData[23] = height;
		}
		
		public function copyMatrix(matrix:Matrix, toIndex:int):void
		{
			rawData[toIndex  ] = matrix.a;
			rawData[toIndex+1] = matrix.d;
			rawData[toIndex+4] = matrix.tx;
			rawData[toIndex+5] = matrix.ty;
		}
		
		public function copyColorTransform(colorTransform:ColorTransform, toIndex:int=0):void
		{
			if(null == colorTransform){
				rawData[toIndex  ] = rawData[toIndex+1] = rawData[toIndex+2] = rawData[toIndex+3] = 1;
				rawData[toIndex+4] = rawData[toIndex+5] = rawData[toIndex+6] = rawData[toIndex+7] = 0;
			}else{
				rawData[toIndex  ] = colorTransform.redMultiplier;
				rawData[toIndex+1] = colorTransform.greenMultiplier;
				rawData[toIndex+2] = colorTransform.blueMultiplier;
				rawData[toIndex+3] = colorTransform.alphaMultiplier;
				rawData[toIndex+4] = colorTransform.redOffset;
				rawData[toIndex+5] = colorTransform.greenOffset;
				rawData[toIndex+6] = colorTransform.blueOffset;
				rawData[toIndex+7] = colorTransform.alphaOffset;
			}
		}
	}
}