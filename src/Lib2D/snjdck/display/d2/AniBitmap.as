package snjdck.display.d2
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class AniBitmap extends Sprite
	{
		private var bitmap:Bitmap;
		private var _bmdList:Array;
		private var _bmdIndex:int;
		
		private var _isPlaying:Boolean;
		private var _repeatCount:int;
		
		private var _rewind:Boolean;
		private var _reverse:Boolean;
		
		public function AniBitmap(bmdList:Array)
		{
			bitmap = new Bitmap();
			bitmap.addEventListener(Event.ENTER_FRAME, __onEnterFrame);
			addChild(bitmap);
			
			this.bmdList = bmdList;
		}
		
		public function clone():AniBitmap
		{
			return new AniBitmap(bmdList);
		}
		
		private function __onEnterFrame(evt:Event):void
		{
			if(false == _isPlaying){
				return;
			}
			
			if(totalFrames <= 1){
				return;
			}
			
			if(_reverse){
				if(currentFrame > 0){
					--currentFrame;
				}else{//当前播放到第一帧
					if(_repeatCount > 0){
						--_repeatCount;
					}else if(0 == _repeatCount){
						_isPlaying = false;
						return;
					}
					
					_reverse = false;
					++currentFrame;
				}
			}else{
				if(currentFrame < totalFrames - 1){
					++currentFrame;
				}else{//当前播放到最后一帧
					if(_repeatCount > 0){
						--_repeatCount;
					}else if(0 == _repeatCount){
						return;
					}
					
					if(_rewind){
						_reverse = true;
						--currentFrame;
					}else{
						currentFrame = 0;
					}
				}
			}
		}
		
		public function get bmdList():Array
		{
			return _bmdList;
		}

		public function set bmdList(value:Array):void
		{
			_bmdList = value;
			currentFrame = 0;
		}
		
		public function get repeatCount():int
		{
			return _repeatCount;
		}
		
		public function set repeatCount(value:int):void
		{
			_repeatCount = value;
		}
		
		public function get rewind():Boolean
		{
			return _rewind;
		}
		
		public function set rewind(value:Boolean):void
		{
			_rewind = value;
		}
		
		public function get currentFrame():int
		{
			return _bmdIndex;
		}
		
		public function set currentFrame(value:int):void
		{
			_bmdIndex = value;
			bitmap.bitmapData = _bmdList[_bmdIndex];
		}
		
		public function get totalFrames():int
		{
			return _bmdList.length;
		}
		
		public function get isPlaying():Boolean
		{
			return _isPlaying;
		}
		
		public function play():void
		{
			_isPlaying = true;
		}
		
		public function stop():void
		{
			_isPlaying = false;
		}
		
		public function toggle():void
		{
			_isPlaying = !_isPlaying;
		}
	}
}