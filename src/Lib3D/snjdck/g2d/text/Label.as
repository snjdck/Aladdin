package snjdck.g2d.text
{
	import flash.events.Event;
	
	import snjdck.g2d.ns_g2d;
	import snjdck.g2d.impl.DisplayObject2D;
	import snjdck.g2d.render.Render2D;
	import snjdck.gpu.asset.AssetMgr;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.render.instance.InstanceRender;
	import snjdck.gpu.support.QuadRender;
	import snjdck.shader.ShaderName;
	
	import string.isBlankStr;
	
	use namespace ns_g2d;
	
	public class Label extends DisplayObject2D
	{
		static protected const textFactory:TextFactory = new TextFactory();
		
		protected var charList:CharInfoList;
		private var _text:String = "";
		private var _fontSize:int;
		
		public var selectable:Boolean;
		
		ns_g2d var _scrollV:int;
		ns_g2d var _bottomScrollV:int;
		ns_g2d var _maxScrollV:int;
		ns_g2d var _numLines:int;
		
		private var textInstanceData:TextInstanceData;
		
		public function Label()
		{
			_fontSize = 12;
			charList = new CharInfoList(this);
			width = 100;
			height = 100;
			textColor[0] = 1;
			textColor[1] = 1;
			textColor[2] = 1;
			textColor[3] = 1;
			var smooth:Number = 1/16;//0-4
			var buffer:Number = 0.5; //0.1 - 0.7
			textColor[4] = buffer - smooth;
			textColor[5] = smooth + smooth;
			textColor[6] = 2;
			textColor[7] = 3;
			
			textInstanceData = new TextInstanceData(charList, _fontSize);
		}
		
		public function get visibleLines():int
		{
			return int(height / fontSize);
		}
		
		public function get numLines():int
		{
			return _numLines;
		}
		
		public function get text():String
		{
			return _text;
		}

		public function set text(value:String):void
		{
			_bottomScrollV = 0;
			_maxScrollV = 0;
			charList.clear();
			if(Boolean(value)){
				_text = value;
				textFactory.getCharList(_text, charList);
			}else{
				_text = "";
			}
			notify(Event.CHANGE, null);
		}
		
		public function get fontSize():int
		{
			return _fontSize;
		}
		
		public function set fontSize(value:int):void
		{
			if(_fontSize == value){
				return;
			}
			_fontSize = value;
			text = _text;
			textInstanceData.fontSize = value;
		}

		override public function hasVisibleArea():Boolean
		{
			return super.hasVisibleArea() && Boolean(text) && !isBlankStr(text);
		}
		
		override protected function onDraw(render2d:Render2D, context3d:GpuContext):void
		{
			if(charList.charCount <= 0){
				return;
			}
			
			context3d.save();
//			context3d.program = AssetMgr.Instance.getProgram(ShaderName.TEXT_2D);
			context3d.program = AssetMgr.Instance.getProgram("text2dx");
			
			context3d.setFc(0, textColor);
			textFactory.setTexture(context3d);
			
			InstanceRender.Instance.setVc(render2d, prevWorldMatrix);
			InstanceRender.Instance.draw(context3d, textInstanceData);
			
			context3d.restore();
			QuadRender.Instance.drawBegin(context3d);
		}
		
		private const textColor:Vector.<Number> = new Vector.<Number>(8, true);
		
		public function get scrollV():int
		{
			return _scrollV;
		}
		
		public function set scrollV(value:int):void
		{
			_scrollV = value;
			charList.clear();
			if(Boolean(text)){
				textFactory.getCharList(_text, charList);
			}
		}
		
		public function get bottomScrollV():int
		{
			return _bottomScrollV;
		}
		
		public function get maxScrollV():int
		{
			return _maxScrollV;
		}
	}
}