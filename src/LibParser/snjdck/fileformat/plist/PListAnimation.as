package snjdck.fileformat.plist
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class PListAnimation extends Sprite
	{
		private var _player:PListSpritePlayer;
		private var _frameList:Array;
		private var _frameIndex:int;
		
		public function PListAnimation(player:PListSpritePlayer, frameList:Array)
		{
			this._player = player;
			this._frameList = frameList;
			this._frameIndex = -1;
			
			__onEnterFrame(null);
			if(_frameList.length > 1){
				play();
			}
		}
		
		public function clone():PListAnimation
		{
			return new PListAnimation(_player, _frameList);
		}
		
		public function play():void
		{
			if(isPlaying){
				return;
			}
			addEventListener(Event.ENTER_FRAME, __onEnterFrame);
		}
		
		public function stop():void
		{
			if(false == isPlaying){
				return;
			}
			removeEventListener(Event.ENTER_FRAME, __onEnterFrame);
		}
		
		public function get isPlaying():Boolean
		{
			return hasEventListener(Event.ENTER_FRAME);
		}
		
		private function __onEnterFrame(evt:Event):void
		{
			_frameIndex = (_frameIndex + 1) % _frameList.length;
			graphics.clear();
			_player.drawFrame(_frameList[_frameIndex], graphics);
		}
	}
}