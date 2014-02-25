package snjdck.media.audio
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	
	[Event(name="ioError", 		type="flash.events.IOErrorEvent")]
	[Event(name="open", 		type="flash.events.Event")]
	[Event(name="complete", 	type="flash.events.Event")]
	[Event(name="soundComplete",type="flash.events.Event")]
	
	public class AudioCore extends EventDispatcher
	{
		private const context:SoundLoaderContext = new SoundLoaderContext();
		private const transform:SoundTransform = new SoundTransform();
		
		private var sound:Sound;
		private var channel:SoundChannel;
		
		private var _position:Number;
		private var _percentLoaded:Number;
		
		public function AudioCore()
		{
			super();
			//
			_position = 0;
			_percentLoaded = 0;
		}
				
		public function load(url:String):void
		{
			if(null == sound)
			{
				sound = new Sound();
				addSoundEventListener(sound);//添加sound的事件侦听器
				sound.load(new URLRequest(url), context);
			}
		}
		
		public function unload():void
		{
			if(sound)
			{
				stop();//销毁channel对象
				//
				removeSoundEventListener(sound);//注销sound的事件侦听器
				//
				try{
					sound.close();
				}catch(e:Error){
				}finally{
					sound = null;
				}
			}
		}
		
		public function play():void
		{
			if(sound && !channel)
			{
				channel = sound.play(_position, 0, transform);
				channel.addEventListener(Event.SOUND_COMPLETE, __onSoundComplete);
			}
		}
		
		public function pause():void
		{
			if(channel)
			{
				_position = channel.position;
				channel.removeEventListener(Event.SOUND_COMPLETE, __onSoundComplete);
				channel.stop();
				channel = null;
			}
		}
		
		public function stop():void
		{
			pause();
			_position = 0;
		}
		
		public function get position():Number
		{
			return channel ? channel.position : _position;
		}
		
		public function get duration():Number
		{
			return sound.length / this.percentLoaded;
		}
		
		public function set percentPlayed(value:Number):void
		{
			pause();
			_position = duration * value;
			play();
		}
		
		public function get bufferTime():Number
		{
			return context.bufferTime;
		}
		
		public function set bufferTime(value:Number):void
		{
			context.bufferTime = value;
		}
		
		public function get percentLoaded():Number
		{
			return this._percentLoaded;
		}
		
		public function get volume():Number
		{
			return transform.volume;
		}
		
		public function set volume(value:Number):void
		{
			transform.volume = value;
			updateTransform();
		}
		
		public function get pan():Number
		{
			return transform.pan;
		}
		
		public function set pan(value:Number):void
		{
			transform.pan = value;
			updateTransform();
		}
		
		private function updateTransform():void
		{
			if(channel){
				channel.soundTransform = transform;
			}
		}
		
		public function get isBuffering():Boolean
		{
			return sound ? sound.isBuffering : false;
		}
		
		private function __onSoundComplete(evt:Event):void 			{ dispatchEvent(evt); }
		private function __onOpen(evt:Event):void 					{ dispatchEvent(evt); }
		private function __onIOError(evt:IOErrorEvent):void 		{ dispatchEvent(evt); }
		private function __onLoaded(evt:Event):void 				{ dispatchEvent(evt); }
		private function __onLoading(evt:ProgressEvent):void 		{ _percentLoaded = sound.bytesLoaded / sound.bytesTotal; }
		
		private function addSoundEventListener(target:Sound):void
		{
			target.addEventListener(Event.OPEN, 				__onOpen);
			target.addEventListener(IOErrorEvent.IO_ERROR, 		__onIOError);
			target.addEventListener(Event.COMPLETE, 			__onLoaded);
			target.addEventListener(ProgressEvent.PROGRESS, 	__onLoading);
		}
		
		private function removeSoundEventListener(target:Sound):void
		{
			target.removeEventListener(Event.OPEN, 				__onOpen);
			target.removeEventListener(IOErrorEvent.IO_ERROR, 	__onIOError);
			target.removeEventListener(Event.COMPLETE, 			__onLoaded);
			target.removeEventListener(ProgressEvent.PROGRESS, 	__onLoading);
		}
	}
}