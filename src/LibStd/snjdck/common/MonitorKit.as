package snjdck.common
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.getTimer;
	
	import stdlib.constant.Unit;
	
	import stdlib.factory.newShape;

	public class MonitorKit extends Sprite
	{
		static private const LINE_THICKNESS:Number = 2;
		static private const MEMORY_USED_COLOR:uint = 0xFF00;
		static private const MEMORY_UNUSED_COLOR:uint = 0xFFFF00;
		
		static public const NUM_RECORD:int = 100;
		
		private var delay:int;//数据采样间隔时间
		
		private var numFrame:int;//已经运行的帧数
		
		private var elapsed:int;			//已经运行的时间
		private var last:int;				//上次记录的时间
		private var now:int;				//现在记录的时间
		
		private var fps:Number;				//每秒运行多少帧
		private var processMem:Number;		//进程的内存使用量
		private var usedMem:Number;			//使用的内存
		private var unusedMem:Number;		//空闲的内存
		
		private var maxUsedMem:Number = 0;
		private var maxUnusedMem:Number = 0;
		
		private const FpsRecord:Vector.<Number> = new <Number>[];
		private const UsedMemRecord:Vector.<Number> = new <Number>[];
		private const UnusedMemRecord:Vector.<Number> = new <Number>[];
		
		private var label:TextField;
		private var g:Graphics;
		
		public function MonitorKit(delay:int=500)//刷新频率为0.5秒
		{
			this.delay = delay;
			
			this.mouseEnabled = false;
			this.mouseChildren = false;
			
			with(graphics)
			{
				beginFill(0, 0.4);
				drawRect(0, 0, 200, 140);
				endFill();
				
				lineStyle(1, 0x000000, 0.4);
				moveTo(0, 100);
				lineTo(200, 100);
			}
			
			this.g = newShape(this).graphics;
			
			createLabel();
			
			last = getTimer();
			addEventListener(Event.ENTER_FRAME, __onEnterFrame);
		}
		
		private function __onEnterFrame(evt:Event):void
		{
			now = getTimer();
			++numFrame;
			elapsed = now - last;
			
			if(elapsed >= delay)
			{
				fps = 1000 * numFrame / elapsed;
				processMem = System.privateMemory * Unit.MB;
				usedMem = System.totalMemoryNumber * Unit.MB;
				unusedMem = System.freeMemory * Unit.MB;
				
				if(usedMem > maxUsedMem)		maxUsedMem = usedMem;
				if(unusedMem > maxUnusedMem)	maxUnusedMem = unusedMem;
				
				updateInfo();
				
				numFrame = 0;
				last = now;
			}
			
			updateUI();
		}
		
		private function updateInfo():void
		{
			label.htmlText = "FPS:\t" + fps.toFixed(0) + "/" + stage.frameRate.toFixed(0)
					+ "\t\tMem:\t" + processMem.toFixed(2)
					+ "(M)\n<font color='#" + MEMORY_USED_COLOR.toString(16) + "'>Used:\t\t"
					+ usedMem.toFixed(2) + " / " + maxUsedMem.toFixed(2)
					+ " (M)</font>\n<font color='#" + MEMORY_UNUSED_COLOR.toString(16) + "'>Free:\t\t"
					+ unusedMem.toFixed(2) + " / " + maxUnusedMem.toFixed(2)
					+ " (M)</font>";
		}
		
		private function updateUI():void
		{
			if(FpsRecord.push(fps) > NUM_RECORD)				FpsRecord.shift();
			if(UsedMemRecord.push(usedMem) > NUM_RECORD)		UsedMemRecord.shift();
			if(UnusedMemRecord.push(unusedMem) > NUM_RECORD)	UnusedMemRecord.shift();
			
			var i:int, n:int;
			
			g.clear();
			
			//绘制cpu曲线
			g.lineStyle(LINE_THICKNESS, 0xFFFFFF);
			for(i=0, n=FpsRecord.length; i<n; i++){
				draw(i, 100 * FpsRecord[i] / stage.frameRate);
			}
			
			//绘制内存使用曲线
			g.lineStyle(LINE_THICKNESS, MEMORY_USED_COLOR);
			for(i=0, n=UsedMemRecord.length; i<n; i++){
				draw(i, 100 * (1 - UsedMemRecord[i] / maxUsedMem));
			}
			
			//绘制空闲内存曲线
			g.lineStyle(LINE_THICKNESS, MEMORY_UNUSED_COLOR);
			for(i=0, n=UnusedMemRecord.length; i<n; i++){
				draw(i, 100 * (1 - UnusedMemRecord[i] / maxUnusedMem));
			}
		}
		
		private function draw(px:Number, value:Number):void
		{
			if(px > 0){
				g.lineTo(px*2, value);
			}else{
				g.moveTo(0, value);
			}
		}
		
		private function createLabel():void
		{
			label = new TextField();
			
			label.autoSize = TextFieldAutoSize.LEFT;
			label.defaultTextFormat = new TextFormat("Verdana", 10, 0xFFFFFF, null, null, null, null, null, TextFormatAlign.LEFT);
			
			label.y = 100;
			label.text = "Loading...";
			
			addChild(label);
		}
	}
}