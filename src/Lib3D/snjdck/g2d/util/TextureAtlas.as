package snjdck.g2d.util
{
	import flash.geom.Rectangle;
	
	import snjdck.g2d.impl.Texture2D;
	import snjdck.gpu.asset.IGpuTexture;
	
	import string.beginWith;

	final public class TextureAtlas
	{
		private var _texture:IGpuTexture;
		private var _subTextureDict:Object;
		
		public function TextureAtlas(texture:IGpuTexture, atlasXml:XML)
		{
			_texture = texture;
			_subTextureDict = {};
			parseAtlasXml(atlasXml);
		}
		
		private function parseAtlasXml(atlasXml:XML):void
		{
			for each(var subTexture:XML in atlasXml.SubTexture)
			{
				var name:String        = subTexture.attribute("name");
				var x:Number           = parseFloat(subTexture.attribute("x"));
				var y:Number           = parseFloat(subTexture.attribute("y"));
				var width:Number       = parseFloat(subTexture.attribute("width"));
				var height:Number      = parseFloat(subTexture.attribute("height"));
				var frameX:Number      = parseFloat(subTexture.attribute("frameX"));
				var frameY:Number      = parseFloat(subTexture.attribute("frameY"));
				var frameWidth:Number  = parseFloat(subTexture.attribute("frameWidth"));
				var frameHeight:Number = parseFloat(subTexture.attribute("frameHeight"));
				
				var region:Rectangle = new Rectangle(x, y, width, height);
				var frame:Rectangle  = (frameWidth > 0 && frameHeight > 0) ? new Rectangle(frameX, frameY, frameWidth, frameHeight) : null;
				
				_subTextureDict[name] = [region, frame];
			}
		}
		
		public function getTexture(name:String):Texture2D
		{
			var info:Array = _subTextureDict[name];
			var subTexture:Texture2D = new Texture2D(_texture);
			subTexture.region = info[0];
			subTexture.frame = info[1];
			return subTexture;
		}
		
		public function getTextures(prefix:String=""):Vector.<Texture2D>
		{
			var textures:Vector.<Texture2D> = new <Texture2D>[];
			var nameList:Vector.<String> = new <String>[];
			var name:String;
			
			for(name in _subTextureDict){
				if(beginWith(name, prefix)){
					nameList.push(name);
				}
			}
			
			nameList.sort(Array.CASEINSENSITIVE);
			
			for each(name in nameList){
				textures.push(getTexture(name));
			}
			
			return textures;
		}
	}
}