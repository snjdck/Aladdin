package snjdck.g2d.text
{
	import flash.events.Event;
	
	import snjdck.g2d.ns_g2d;
	import snjdck.g2d.impl.DisplayObject2D;
	import snjdck.g2d.render.Render2D;
	import snjdck.gpu.asset.AssetMgr;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.render.instance.InstanceRender;
	import snjdck.shader.ShaderName;
	
	import string.isBlankStr;
	
	use namespace ns_g2d;
	
	public class Label extends DisplayObject2D
	{
		protected var textFactory:TextFactory;
		
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
			
			textFactory = TextFactoryMgr.Fetch(_fontSize);
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
			textFactory = TextFactoryMgr.Fetch(_fontSize);
			text = _text;
			textInstanceData.fontSize = value;
		}

		override public function isVisible():Boolean
		{
			return super.isVisible() && Boolean(text) && !isBlankStr(text);
		}
		
		override protected function onDraw(render2d:Render2D, context3d:GpuContext):void
		{
			if(charList.charCount <= 0){
				return;
			}
			
			context3d.save();
			context3d.program = AssetMgr.Instance.getProgram(ShaderName.TEXT_2D);
			
			context3d.setFc(0, textColor);
			textInstanceData.textureSize = textFactory.textureSize;
			textFactory.setTexture(context3d);
			
			InstanceRender.Instance.setVc(render2d, worldTransform);
			InstanceRender.Instance.drawQuad(context3d, textInstanceData, charList.charCount);
			
			context3d.restore();
		}
		
		private const textColor:Vector.<Number> = new Vector.<Number>(4, true);
		
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