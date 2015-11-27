package snjdck.g2d.text
{
	import snjdck.gpu.render.instance.IInstanceData;

	internal class TextInstanceData implements IInstanceData
	{
		private var charList:CharInfoList;
		public var fontSize:int;
		
		public function TextInstanceData(charList:CharInfoList, fontSize:int)
		{
			this.charList = charList;
			this.fontSize = fontSize;
		}
		
		public function get numRegisterPerInstance():int
		{
			return 1;
		}
		
		public function get numInstances():int
		{
			return charList.charCount;
		}
		
		public function initConstData(constData:Vector.<Number>):void
		{
			constData[12] = fontSize;
			constData[13] = 16 / 2048;
			constData[14] = 0;
			constData[15] = 1;
		}
		
		public function updateConstData(constData:Vector.<Number>, instanceOffset:int, instanceCount:int):void
		{
			var offset:int = 16;
			for(var i:int=0; i<instanceCount; ++i){
				var charInfo:CharInfo = charList.getCharAt(instanceOffset+i);
				constData[offset++] = charInfo.x;
				constData[offset++] = charInfo.y;
				constData[offset++] = charInfo.uvX;
				constData[offset++] = charInfo.uvY;
			}
		}
	}
}