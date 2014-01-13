package snjdck.media.sound
{
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.utils.ByteArray;
	
	public class SamplePlayer extends Sound
	{
		private var _soundSample:ISoundSample;
		
		public function SamplePlayer(soundSample:ISoundSample)
		{
			addEventListener(SampleDataEvent.SAMPLE_DATA, __onSampleData);
			_soundSample = soundSample;
		}
		
		private function __onSampleData(evt:SampleDataEvent):void
		{
			var output:ByteArray = evt.data;
			var offset:int = evt.position;
			const n:int = Math.min(4096, _soundSample.length - offset);
			for(var i:int=0; i<n; i++){
				_soundSample.writeData(output, offset+i);
			}
		}
	}
}