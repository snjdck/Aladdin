package snjdck.fileformat.plist
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Point;
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
				if (null == result) continue;
				var index:int = parseInt(result[1]);
				frameList[index] = frameName;
			}
			while(null == frameList[0]){
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
				regAnimation(name, new RegExp(name+"(?:_(\\d+)|)"));
			}
			return new PListAnimation(this, animationDict[name]);
		}
		
		public function drawFrame(frameName:String, g:Graphics):void
		{
			var frameData:Object = config.frames[frameName];
			
			adjustFrameData(frameData);
			
			g.beginFill(0, 0);
			g.drawRect(0, 0, frameData.sourceSize.x, frameData.sourceSize.y);
			g.endFill();
			
			prepareBitmapMatrix(bitmapMatrix, frameData.frame, frameData.sourceColorRect, frameData.rotated);
			
			g.beginBitmapFill(bitmapData, bitmapMatrix, false, true);
			GDI.drawRect(g, frameData.sourceColorRect);
			g.endFill();
		}
		
		public function getAniNameList():Array
		{
			return $dict.getKeys(config.frames);
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
		
		static private function adjustFrameData(frameData:Object):void
		{
			if(frameData.hasOwnProperty("frame")){
				return;
			}
			frameData.sourceSize = new Point(frameData.originalWidth, frameData.originalHeight);
			frameData.sourceColorRect = new Rectangle(frameData.offsetX, frameData.offsetY, frameData.width, frameData.height);
			frameData.frame = new Rectangle(frameData.x, frameData.y, frameData.originalWidth, frameData.originalHeight);
		}
	}
}