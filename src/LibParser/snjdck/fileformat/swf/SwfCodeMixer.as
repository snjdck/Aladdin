package snjdck.fileformat.swf
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.factory.newBuffer;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class SwfCodeMixer extends Sprite
	{
		private var file:FileReference;
		
		public function SwfCodeMixer()
		{
			file = new FileReference();
			file.addEventListener(Event.SELECT, __onSelect);
			file.addEventListener(Event.COMPLETE, __onComplete);
			file.browse([new FileFilter("swf file", "*.swf")]);
		}
		
		private function __onSelect(evt:Event):void
		{
			file.load();
		}
		
		private function __onComplete(evt:Event):void
		{
			file.removeEventListener(Event.SELECT, __onSelect);
			file.removeEventListener(Event.COMPLETE, __onComplete);
			
			file.data.endian = Endian.LITTLE_ENDIAN;
			
			var swf:SwfFile = new SwfFile();
			swf.read(file.data);
			
//			swf.mixCode();
			swf.addTelemetryTag();
			
			var t:ByteArray = newBuffer();
			swf.write(t);
			file.save(t, file.name.split(".")[0] + "Mixed.swf");
		}
	}
}