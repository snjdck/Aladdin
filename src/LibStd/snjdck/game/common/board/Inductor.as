package snjdck.game.common.board
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	internal class Inductor extends Layer
	{
		private static const BOX_OVER			:String = "boxOver";
		private static const BOX_OUT			:String = "boxOut";
		private static const BOX_CLICK			:String = "boxClick";
		
		private var numHor:int;				//横向格子数量
		private var numVer:int;				//纵向格子数量
		
		private var _focusX:int;				//横向第几个格子
		private var _focusY:int;				//纵向第几个格子
		
		public function Inductor(numHor:int, numVer:int, boxWidth:int, boxHeight:int, gapWidth:int, gapHeight:int)
		{
			super(boxWidth, boxHeight, gapWidth, gapHeight);
			
			this.mouseChildren = true;
			
			this.numHor = numHor;
			this.numVer = numVer;
			
			initBox();
		}
		
		public function get focusX():int { return _focusX; }
		public function get focusY():int { return _focusY; }
		
		public function set onBoxOver(handler:Function):void 		{ this.addEventListener(BOX_OVER,	handler); }
		public function set onBoxOut(handler:Function):void 		{ this.addEventListener(BOX_OUT,	handler); }
		public function set onBoxClick(handler:Function):void 		{ this.addEventListener(BOX_CLICK,	handler); }
			
		private function initBox():void
		{
			var i:int = 0;
			var j:int = 0;
			
			for(; i<numVer; i++)
			{
				for(j=0; j<numHor; j++)
				{
					this.addBox(j, i);
				}
			}
		}
		
		private function addBox(px:int, py:int):void
		{
			var w:int = boxWidth + gapWidth;
			var h:int = boxHeight + gapHeight;
			
			var box:Box = new Box(px, py);
			
			box.draw(boxWidth, boxHeight);
			
			box.x = px * w;
			box.y = py * h;
			
			box.addEventListener(MouseEvent.MOUSE_OVER,	__onBoxOver);
			box.addEventListener(MouseEvent.MOUSE_OUT,	__onBoxOut);
			box.addEventListener(MouseEvent.CLICK,		__onBoxClick);
			
			this.addChild(box);
		}
		
		private function __onBoxOver(evt:MouseEvent):void
		{
			var box:Box = evt.currentTarget as Box;
			this.doBoxOverAt(box.px, box.py);
		}
		
		private function __onBoxOut(evt:MouseEvent):void
		{
			var box:Box = evt.currentTarget as Box;
			this.doBoxOutAt(box.px, box.py);
		}
		
		private function __onBoxClick(evt:MouseEvent):void
		{
			var box:Box = evt.currentTarget as Box;
			this.doBoxClickAt(box.px, box.py);
		}
		
		public function doBoxOverAt(px:int, py:int):void
		{
			_focusX = px;
			_focusY = py;
			this.dispatchEvent(new Event(BOX_OVER));
		}
		
		public function doBoxOutAt(px:int, py:int):void
		{
			_focusX = px;
			_focusY = py;
			this.dispatchEvent(new Event(BOX_OUT));
		}
		
		public function doBoxClickAt(px:int, py:int):void
		{
			_focusX = px;
			_focusY = py;
			this.dispatchEvent(new Event(BOX_CLICK));
		}
		//over
	}
}
//*
import flash.display.Sprite;

class Box extends Sprite
{
	private var _px:int;
	private var _py:int;
	
	public function Box(px:int, py:int)
	{
		super();
		//
		this._px = px;
		this._py = py;
	}
	
	public function get px():int { return this._px; }
	public function get py():int { return this._py; }
	public function draw(w:int, h:int):void
	{
		with(graphics)
		{
			beginFill(0, 0);
			drawRect(0, 0, w, h);
			endFill();
		}
	}
}
//*/