package snjdck.g2d.text
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	import snjdck.g2d.text.drawer.TextDrawer;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuTexture;

	internal class TextFactory
	{
		static public const textureWidth:int = 2048;
		static public const textureHeiht:int = 2048;
		
		private const tf:TextDrawer = new TextDrawer();
		
		private const charDict:Object = {};
		
		private var nextX:int;
		private var nextY:int;
		
		private var gpuTexture:GpuTexture;
		private var texture:BitmapData;
		private var isTextureDirty:Boolean;
		
		public function TextFactory()
		{
			texture = new BitmapData(textureWidth, textureHeiht, true, 0);
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
		
		public function getCharList(text:String, output:CharInfoList):void
		{
			var charCount:int = text.length;
			for(var i:int=0; i<charCount; ++i){
				var char:String = text.charAt(i);
				switch(char){
					case "\n":
						output.newline();
						break;
					case "\r":
					case "\t":
						break;
					default:
						output.push(getChar(char));
				}
			}
		}
		
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
	}
}