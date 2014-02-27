package snjdck.tesla.kernel.services.impl
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	
	import math.truncate;
	
	import flash.signals.ISignal;
	import flash.signals.Signal;
	import snjdck.tesla.kernel.services.IAssetService;
	import snjdck.tesla.kernel.services.ISoundService;
	import snjdck.tesla.kernel.services.support.Service;
	import snjdck.tesla.kernel.services.support.SoundContext;

	public class SoundService extends Service implements ISoundService
	{
		[Inject]
		public var assetService:IAssetService;
		
		private const soundVolumeChangeSignal:Signal = new Signal(Number);
		private const musicVolumeChangeSignal:Signal = new Signal(Number);
		
		private var _soundVolume:Number = 1;
		private var _musicVolume:Number = 1;
		
		public function SoundService()
		{
		}
		
		public function RepeatSound(assetName:String):Function
		{
			var channel:SoundChannel = playSoundImpl(assetName, int.MAX_VALUE, soundVolume);
			return function():void{
				if(channel){
					channel.stop();
					channel = null;
				}
			};
		}
		
		public function playSoundOnce(assetName:String):void
		{
			playSoundImpl(assetName, 0, soundVolume);
		}
		
		private function playSoundImpl(assetName:String, loopCount:int, volume:Number):SoundChannel
		{
			var sound:Sound = assetService.getSound(assetName);
			if(null == sound){
				return null;
			}
			return sound.play(0, loopCount, new SoundTransform(volume));
		}
		
		public function get soundVolume():Number
		{
			return _soundVolume;
		}
		
		public function set soundVolume(value:Number):void
		{
			_soundVolume = truncate(value);
			soundVolumeChangeSignal.notify(soundVolume);
		}
		
		public function get musicVolume():Number
		{
			return _musicVolume;
		}
		
		public function set musicVolume(value:Number):void
		{
			_musicVolume = truncate(value);
			musicVolumeChangeSignal.notify(musicVolume);
		}
		
		private function setChannelVolume(channel:SoundChannel, value:Number):void
		{
			var soundTransform:SoundTransform = channel.soundTransform;
			soundTransform.volume = value;
			channel.soundTransform = soundTransform;
		}
		
		public function get mute():Boolean
		{
			return 0 == SoundMixer.soundTransform.volume;
		}
		
		public function set mute(value:Boolean):void
		{
			if(mute == value){
				return;
			}
			var soundTransform:SoundTransform = SoundMixer.soundTransform;
			soundTransform.volume = value ? 0 : 1;
			SoundMixer.soundTransform = soundTransform;
		}
		
		private function play(sound:Sound, volume:Number, volumeChangeSignal:ISignal):Function
		{
			if(null == sound){
				return null;
			}
			var soundContext:SoundContext = new SoundContext(
				sound.play(0, int.MAX_VALUE, new SoundTransform(0)),
				volume,
				volumeChangeSignal
			);
			return soundContext.stop;
		}
	}
}