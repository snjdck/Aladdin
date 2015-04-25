package snjdck.g2d.text
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import dict.hasKey;
	
	import snjdck.gpu.App3D;
	import snjdck.gpu.asset.GpuTexture;
	import snjdck.gpu.asset.IGpuTexture;

	public class TextFactory
	{
		static public const textureWidth:int = 2048;
		static public const textureHeiht:int = 2048;
		
		private var tf:TextField;
		private var format:TextFormat;
		private var matrix:Matrix = new Matrix();
		
		private const charDict:Object = {};
		
		private var nextX:int;
		private var nextY:int;
		
		public var _gpuTexture:GpuTexture;
		private var texture:BitmapData;
		private var isTextureDirty:Boolean;
		
		public function TextFactory()
		{
			texture = new BitmapData(2048, 2048, true, 0);
			_gpuTexture = new GpuTexture(texture.width, texture.height);
			
			App3D.app.stage.addChild(new Bitmap(texture)).y = 200;
			
			format = new TextFormat("宋体", 12, 0xFF0000);
			tf = new TextField();
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.defaultTextFormat = format;
		}
		
		public function get gpuTexture():IGpuTexture
		{
			return _gpuTexture;
		}
		
		private function drawChar(offsetX:int, offsetY:int):void
		{
			matrix.tx = offsetX - 2;
			matrix.ty = offsetY - 2;
			texture.draw(tf, matrix);
			isTextureDirty = true;
		}
		
		public function getCharList(text:String, output:CharInfoList):void
		{
			var charInfo:Rectangle;
			var charCount:int = text.length;
			for(var i:int=0; i<charCount; ++i){
				var char:String = text.charAt(i);
				if(hasKey(charDict, char)){
					charInfo = charDict[char];
				}else{
					charInfo = new Rectangle();
					charDict[char] = charInfo;
					
					tf.text = char;
					charInfo.x = nextX;
					charInfo.y = nextY;
					charInfo.width = tf.textWidth;
					charInfo.height = tf.textHeight;
					
					drawChar(charInfo.x, charInfo.y);
					
					nextX += charInfo.width;
				}
				output.push(charInfo);
			}
			if(isTextureDirty){
				_gpuTexture.upload(texture);
				isTextureDirty = false;
			}
		}
	}
}