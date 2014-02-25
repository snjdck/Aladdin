package snjdck.fileformat.plist
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import snjdck.GDI;
	
	public class PListSpritePlayer
	{
		private const animationDict:Object = {};
		static private const bitmapMatrix:Matrix = new Matrix();
		
		private var config:Object;
		private var bitmapData:BitmapData;
		
		public function PListSpritePlayer(config:Object, bitmapData:BitmapData)
		{
			this.config = config;
			this.bitmapData = bitmapData;
		}
		
		private function regAnimation(name:String, pattern:RegExp):void
		{
			var frameList:Array = [];
			for(var frameName:String in config.frames){
				var result:Object = pattern.exec(frameName);
				if(null == result){
					continue;
				}
				var index:int = parseInt(result[1]);
				frameList[index] = frameName;
			}
			if(null == frameList[0]){
				frameList.shift();
			}
			animationDict[name] = frameList;
		}
		
		public function createAnimation(name:String=null):PListAnimation
		{
			if(null == name){
				name = "";
			}
			if(!animationDict.hasOwnProperty(name)){
				regAnimation(name, new RegExp(getKeyName(name+"(\\d+)")));
			}
			return new PListAnimation(this, animationDict[name]);
		}
		
		private function getKeyName(key:String):String
		{
			return prefix + "_" + key + "." + suffix;
		}
		
		private function get prefix():String
		{
			var fileName:String = config.metadata.textureFileName;
			var index:int = fileName.search(/\d*\.png/);
			return fileName.slice(0, index);
		}
		
		private function get suffix():String
		{
			var fileName:String = config.metadata.textureFileName;
			var index:int = fileName.lastIndexOf(".");
			return fileName.slice(index+1);
		}
		
		public function drawFrame(frameName:String, g:Graphics):void
		{
			var frameData:Object = config.frames[frameName];
			
			g.beginFill(0, 0);
			g.drawRect(0, 0, frameData.sourceSize.x, frameData.sourceSize.y);
			g.endFill();
			
			prepareBitmapMatrix(bitmapMatrix, frameData.frame, frameData.sourceColorRect, frameData.rotated);
			
			g.beginBitmapFill(bitmapData, bitmapMatrix, false, true);
			GDI.drawRect(g, frameData.sourceColorRect);
			g.endFill();
		}
		
		static private function prepareBitmapMatrix(matrix:Matrix, frame:Rectangle, sourceColorRect:Rectangle, rotated:Boolean):void
		{
			matrix.identity();
			matrix.translate(-frame.x, -frame.y);
			if(rotated){
				bitmapMatrix.rotate(-0.5 * Math.PI);
				bitmapMatrix.translate(0, frame.height);
			}
			matrix.translate(sourceColorRect.x, sourceColorRect.y);
		}
	}
}