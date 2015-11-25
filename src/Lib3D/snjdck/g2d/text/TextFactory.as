package snjdck.g2d.text
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	
	import array.has;
	
	import snjdck.g2d.text.drawer.TextDrawer;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuTexture;

	internal class TextFactory
	{
		static public const TextureSize:int = 2048;
		
		private const tf:TextDrawer = new TextDrawer();
		
		private const charDict:Object = {};
		private const charList:Array = [];
		
		private var nextX:int;
		private var nextY:int;
		
		private var gpuTexture:GpuTexture;
		private var texture:BitmapData;
		private var isTextureDirty:Boolean;
		
		public function TextFactory()
		{
			texture = new BitmapData(TextureSize, TextureSize, true, 0);
			var t = getDefinitionByName("TestText").app.addChild(new Bitmap(texture));
			t.scaleX = t.scaleY = 3;
			gpuTexture = new GpuTexture(texture.width, texture.height);
		}
		
		private function init():void
		{
			for(var i:int=0x21; i<0x7F; ++i){
				tf.appendText(String.fromCharCode(i, 0x20));
			}
			isTextureDirty = true;
		}
		
		public function setTexture(context3d:GpuContext):void
		{
			if(isTextureDirty){
				gpuTexture.upload(texture);
				isTextureDirty = false;
			}
			context3d.texture = gpuTexture;
		}
		
		public function getCharList(text:String, output:CharInfoList):void
		{
			calcCharList(text);
			var charCount:int = text.length;
			for(var i:int=0; i<charCount; ++i){
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
						output.push(charDict[char]);
				}
			}
		}
		
		private function calcCharList(text:String):void
		{
			tf.clear();
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
				if(charDict.hasOwnProperty(char) || has(charList, char)){
					continue;
				}
				tf.appendText(char);
				if(tf.textWidth > TextureSize - nextX){
					tf.removeLastChar();
					generateChar();
					nextX = 0;
					nextY += tf.textHeight;
					tf.setText(char);
				}
				charList.push(char);
			}
			generateChar();
		}
		
		private function generateChar():void
		{
			var charCount:int = charList.length;
			if(charCount <= 0){
				return;
			}
			trace(charList);
			
			for(var i:int=0; i<charCount; ++i){
				var charInfo:Rectangle = tf.getCharBoundaries(i);
				charInfo.offset(nextX, nextY);
				charInfo.x /= TextureSize;
				charInfo.y /= TextureSize;
				charDict[charList[i]] = charInfo;
			}
			
			tf.draw(texture, nextX, nextY);
			isTextureDirty = true;
			
			nextX += tf.textWidth;
			charList.length = 0;
		}
		/*
		private function getChar(char:String):Rectangle
		{
			if(charDict.hasOwnProperty(char)){
				return charDict[char];
			}
			return createChar(char);
		}
		
		private function createChar(char:String):Rectangle
		{
			var charInfo:Rectangle = new Rectangle();
			charDict[char] = charInfo;
			
			tf.setText(char);
			charInfo.x = nextX;
			charInfo.y = nextY;
			charInfo.width = tf.textWidth;
			charInfo.height = tf.textHeight;
			
			tf.draw(texture, charInfo.x, charInfo.y);
			isTextureDirty = true;
			
			nextX += charInfo.width;
			
			return charInfo;
		}
		//*/
	}
}