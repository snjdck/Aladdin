package snjdck.tesla.kernel.services.support
{
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	import flash.signals.ISignal;

	public class SoundContext
	{
		static public function setChannelVolume(channel:SoundChannel, value:Number):void
		{
			var soundTransform:SoundTransform = channel.soundTransform;
			soundTransform.volume = value;
			channel.soundTransform = soundTransform;
		}
		
		static public function tweenSoundTransform(channel:SoundChannel, toVolume:Number, onComplete:Function):void
		{
			var soundTransform:SoundTransform = channel.soundTransform;
//			TweenLite.to(soundTransform, 2, {
//				"volume":toVolume,
//				"onComplete":onComplete,
//				"onUpdate":function():void{
//					channel.soundTransform = soundTransform;
//				}
//			});
		}
		
		private var channel:SoundChannel;
		private var isOpening:Boolean;
		private var isClosing:Boolean;
		private var volumeChangeSignal:ISignal;
		
		public function SoundContext(channel:SoundChannel, volume:Number, volumeChangeSignal:ISignal)
		{
			this.channel = channel;
			this.volumeChangeSignal = volumeChangeSignal;
			
			isOpening = true;
			tweenSoundTransform(channel, volume, __onOpend);
			
			volumeChangeSignal.add(__onVolumeChange);
		}
		
		public function stop():void
		{
			if(null == channel){
				return;
			}
			if(isOpening){
//				TweenLite.killTweensOf(channel);
				isOpening = false;
			}
			if(isClosing){
				return;
			}
			isClosing = true;
			volumeChangeSignal.del(__onVolumeChange);
			tweenSoundTransform(channel, 0, dispose);
		}
		
		public function dispose():void
		{
			if(channel){
				channel.stop();
				channel = null;
			}
		}
		
		private function __onOpend():void
		{
			isOpening = false;
		}
		
		private function __onVolumeChange(newVolume:Number):void
		{
			if(isOpening || isClosing){
				return;
			}
			setChannelVolume(channel, newVolume);
		}
	}
}