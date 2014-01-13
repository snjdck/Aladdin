package snjdck.media
{
	
	import flash.display.Sprite;
	import flash.media.Video;
	import flash.net.NetStream;

	public class VideoScreen extends Sprite
	{
		private var videoWidth:int;
		private var videoHeight:int;
		
		private var hw:Number = 0.75;
		
		private var display:Video;
		private var ns:NetStream;

		public function VideoScreen()
		{
			super();
		}
		
		protected function initChild():void
		{
			display = new Video();
			display.smoothing = true;
			//display.deblocking = 5;
			addChild(display);
		}
		
		public function attachNetStream(ns:NetStream):void
		{
			if(null == ns)
			{
				//注意,当smoothing打开后,clear方法失效
				this.ns = null;
				display.attachNetStream(null);
				display.clear();
				display.visible = false;
			}
			else if(this.ns != ns)
			{
				display.attachNetStream(ns);
				display.visible = true;
				this.ns = ns;
			}
		}
		
		public function set videoInfo(info:Object):void
		{
			if(info && info.width && info.height)
			{
				videoWidth = info.width;
				videoHeight = info.height;
			}
			else
			{
				videoWidth = 320;
				videoHeight = 240;
			}
			
			hw = videoHeight / videoWidth;
			this.autoLayout();
		}
		
		protected function onDraw():void
		{
			with(graphics)
			{
				clear();
				beginFill(0);
				drawRect(0, 0, width, height);
				endFill();
			}
		}
		
		protected function autoLayout():void
		{
			if(hw > (height/width))
			{
				display.y = 0;
				display.height = this.height;
				display.width = display.height / hw;
				display.x = (this.width - display.width) / 2;
			}
			else
			{
				display.x = 0;
				display.width = this.width;
				display.height = display.width * hw;
				display.y = (this.height - display.height) / 2;
			}
		}
		//over
	}
}