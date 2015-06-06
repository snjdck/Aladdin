package snjdck.g2d.text
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	import dict.hasKey;
	
	import snjdck.g2d.text.drawer.TextDrawer;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuTexture;
	import snjdck.gpu.asset.IGpuTexture;

	public class TextFactory
	{
		static public const textureWidth:int = 2048;
		static public const textureHeiht:int = 2048;
		
		static public const Instance:TextFactory = new TextFactory();
		
		private const tf:TextDrawer = new TextDrawer();
		
		private const charDict:Object = {};
		
		private var nextX:int;
		private var nextY:int;
		
		public var _gpuTexture:GpuTexture;
		private var texture:BitmapData;
		private var isTextureDirty:Boolean;
		
		public function TextFactory()
		{
			texture = new BitmapData(textureWidth, textureHeiht, true, 0);
			_gpuTexture = new GpuTexture(texture.width, texture.height);
			
//			App3D.app.stage.addChild(new Bitmap(texture)).y = 200;
		}
		
		public function setTexture(context3d:GpuContext):void
		{
			if(isTextureDirty){
				_gpuTexture.upload(texture);
				isTextureDirty = false;
			}
			context3d.texture = _gpuTexture;
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
					
					tf.setText(char);
					charInfo.x = nextX;
					charInfo.y = nextY;
					charInfo.width = tf.textWidth;
					charInfo.height = tf.textHeight;
					
					tf.draw(texture, charInfo.x, charInfo.y);
					isTextureDirty = true;
					
					nextX += charInfo.width;
				}
				output.push(charInfo);
			}
			
		}
	}
}