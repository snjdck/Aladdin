package snjdck.game.common.board
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import snjdck.game.common.utils.ds.IntMap;

	public class ChessBoard extends Sprite
	{
		public static const BOARD_CHESS_CLICK	:String = "board_chess_click";
		public static const BOARD_CHESS_OVER	:String = "board_chess_over";
		public static const BOARD_CHESS_OUT		:String = "board_chess_out";
		
		private var numHor:int;				//横向格子数量
		private var numVer:int;				//纵向格子数量
		private var boxWidth:int;			//格子宽度
		private var boxHeight:int;			//格子高度
		private var gapWidth:int;			//横向格子间距
		private var gapHeight:int;			//纵向格子间距
		//
		private var inductor:Inductor;
		private var hoverLayer:HoverLayer;
		private var selectedLayer:SelectedLayer;
private var hintLayer:HintLayer;
		private var chessLayer:ChessLayer;
		protected var data:IntMap;
		//
		private var _enabled:Boolean = false;	//默认棋盘处于禁用状态
		
		public function ChessBoard(numHor:int, numVer:int, boxWidth:int, boxHeight:int, gapWidth:int, gapHeight:int)
		{
			super();
			
			this.numHor = numHor;
			this.numVer = numVer;
			this.boxWidth = boxWidth;
			this.boxHeight = boxHeight;
			this.gapWidth = gapWidth;
			this.gapHeight = gapHeight;
			
			init();
		}
		
		protected function init():void
		{
			inductor = new Inductor(numHor, numVer, boxWidth, boxHeight, gapWidth, gapHeight);
			hoverLayer = new HoverLayer(boxWidth, boxHeight, gapWidth, gapHeight);
			selectedLayer = new SelectedLayer(boxWidth, boxHeight, gapWidth, gapHeight);
			data = new IntMap(numHor, numVer);
			
			inductor.onBoxOver = this.__onBoxOver;
			inductor.onBoxOut = this.__onBoxOut;
			inductor.onBoxClick = this.__onBoxClick;
			
			this.addChild(selectedLayer);
			this.addChild(hoverLayer);
			this.addChild(inductor);
		}
		
		//对成员方法的包装,facade模式
		//inductor
		public function get focusX():int 									{ return inductor.focusX; }
		public function get focusY():int 									{ return inductor.focusY; }
		public function get focusValue():int								{ return getValueAt(focusX, focusY); }
		//hoverLayer
		public function setHoverIcon(icon:DisplayObject):void 				{ hoverLayer.setIcon(icon); }
		//selectedLayer
		public function setSelectedIconClass(cls:Class):void 				{ selectedLayer.setIconClass(cls); }
		public function setSelectedAt(px:int, py:int, flag:Boolean):void 	{ selectedLayer.setSelectedAt(px, py, flag); }
		//chessLayer
		public function setChessLayerClass(cls:Class):void
		{
			chessLayer = new cls(boxWidth, boxHeight, gapWidth, gapHeight);
			this.addChildAt(chessLayer, 0);
		}
		
		public function getValueAt(px:int, py:int):int
		{
			return data.getValueAt(px, py);
		}
		
		public function $setValueAt(px:int, py:int, value:int):void
		{
			data.setValueAt(px, py, value);
		}
		
		public function setValueAt(px:int, py:int, value:int):void
		{
			this.$setValueAt(px, py, value);
			chessLayer.setValueAt(px, py, value);
		}
		
		public function reset():void
		{
			data.reset();
			chessLayer.reset();
			selectedLayer.reset();
		}
		
		private function __onBoxOver(evt:Event):void
		{
			if(!sendEvent(BOARD_CHESS_OVER))
			{
				hoverLayer.moveIcon(focusX, focusY);
				hoverLayer.showIcon(true);
			}
		}
		
		private function __onBoxOut(evt:Event):void
		{
			if(!sendEvent(BOARD_CHESS_OUT))
			{
				hoverLayer.showIcon(false);
			}
		}
		
		private function __onBoxClick(evt:Event):void
		{
			if(!sendEvent(BOARD_CHESS_CLICK))
			{
				this.setSelectedAt(focusX, focusY, true);
			}
		}
		
		private function sendEvent(evtType:String):Boolean
		{
			var evt:Event = new Event(evtType, false, true);
			this.dispatchEvent(evt);
			return evt.isDefaultPrevented();
		}
		
		//背景图片注册点为左上角
		public function setBackground(bg:DisplayObject, offsetX:int=0, offsetY:int=0):void
		{
			var w:int = numHor * (boxWidth + gapWidth) - gapWidth;
			var h:int = numVer * (boxHeight + gapHeight) - gapHeight;
			bg.x = 0.5 * (w - bg.width) + offsetX;
			bg.y = 0.5 * (h - bg.height) + offsetY;
			this.addChildAt(bg, 0);
		}
		
		public function get enabled():Boolean { return _enabled; }
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
			//
			this.mouseEnabled = _enabled;
			this.mouseChildren = _enabled;
		}
		//over
	}
}