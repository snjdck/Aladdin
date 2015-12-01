package snjdck.g2d.text
{
	import flash.display.BitmapData;
	
	import snjdck.g2d.text.drawer.TextDrawer;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuTexture;

	internal class TextFactory
	{
		static private const MAX_TEXTURE_SIZE:int = 2048;
		
		private var tf:TextDrawer;
		private var _textureSize:int;
		
		private var gpuTexture:GpuTexture;
		private var texture:BitmapData;
		private var isTextureDirty:Boolean;
		
		private var textLocator:TextLocator;
		private var fontSize:int;
		
		public function TextFactory(fontSize:int)
		{
			this.fontSize = fontSize;
			tf = new TextDrawer(fontSize);
			changeTextureSize(128);
		}
		
		public function get textureSize():int
		{
			return _textureSize;
		}
		
		private function changeTextureSize(value:int):void
		{
			_textureSize = value;
			if(texture != null)
				texture.dispose();
			if(gpuTexture != null)
				gpuTexture.dispose();
			textLocator = new TextLocator(_textureSize, fontSize);
			texture = new BitmapData(_textureSize, _textureSize, true, 0);
			gpuTexture = new GpuTexture(texture.width, texture.height);
		}
		
		public function setTexture(context3d:GpuContext):void
		{
			if(isTextureDirty){
				gpuTexture.upload(texture);
				isTextureDirty = false;
			}
			context3d.texture = gpuTexture;
		}
		
		private var charList:Array = [];
		
		public function getCharList(text:String, output:CharInfoList):void
		{
			charList.length = 0;
			getCharToDraw(text, charList);
			if(!textLocator.canAdd(charList.length)){
				if(_textureSize < MAX_TEXTURE_SIZE){
					changeTextureSize(_textureSize << 1);
					getCharList(text, output);
				}
				return;
			}
			calcCharList(charList);
			for(var i:int=0, n:int=text.length; i<n; ++i){
				var char:String = text.charAt(i);
				switch(char){
					case "\n":
						output.pushNewline();
						break;
					case "\r":
						break;
					case "\t":
						output.pushTab();
						break;
					case " ":
						output.pushBlank();
						break;
					default:
						output.push(textLocator.getInfo(char));
				}
			}
		}
		
		private function calcCharList(charList:Array):void
		{
			textLocator.mark();
			for(var i:int=0, n:int=charList.length; i<n; ++i){
				var char:String = charList[i];
				var isHalfChar:Boolean = tf.isHalfChar(char);
				tf.appendText(char);
				if(isHalfChar){
					tf.appendText(" ");
				}
				if(textLocator.addChar(char, isHalfChar)){
					generateChar();
				}
			}
			generateChar();
		}
		
		private function generateChar():void
		{
			if(textLocator.needUpdate){
				tf.draw(texture, textLocator.markX, textLocator.markY);
				isTextureDirty = true;
				textLocator.mark();
				tf.clear();
			}
		}
		
		private function getCharToDraw(text:String, result:Array):void
		{
			var charCount:int = text.length;
			for(var i:int=0; i<charCount; ++i){
				var char:String = text.charAt(i);
				switch(char){
					case "\n":
					case "\r":
					case "\t":
					case " ":
						continue;
				}
				if(textLocator.hasInfo(char)){
					continue;
				}
				if(result.indexOf(char) < 0){
					result.push(char);
				}
			}
		}
	}
}