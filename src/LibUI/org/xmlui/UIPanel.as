package org.xmlui
{
	import flash.display.Sprite;
	
	public class UIPanel extends Sprite
	{
		public var id:String;
		
		private var _width:Number;
		private var _height:Number;
		
		public var halign:IAlign;
		public var valign:IAlign;
		
		public function UIPanel()
		{
		}
		
		override public function get width():Number
		{
			return _width;
		}
		
		override public function set width(value:Number):void
		{
			var isFirstSet:Boolean = isNaN(_width);
			_width = value;
			if(false == isFirstSet){
				onResize();
			}
		}
		
		override public function get height():Number
		{
			return _height;
		}
		
		override public function set height(value:Number):void
		{
			var isFirstSet:Boolean = isNaN(_height);
			_height = value;
			if(false == isFirstSet){
				onResize();
			}
		}
		
		public function getElementById(elementId:String):*
		{
			if(this.id == elementId){
				return this;
			}
			for(var i:int=0; i<numChildren; i++){
				var panel:UIPanel = getChildAt(i) as UIPanel;
				if(null == panel){
					continue;
				}
				var result:Object = panel.getElementById(elementId);
				if(result){
					return result;
				}
			}
			return null;
		}
		
		public function onResize():void
		{
			if(halign){
				halign.update(this);
			}
			
			if(valign){
				valign.update(this);
			}
			
			for(var i:int=0; i<numChildren; i++){
				var panel:UIPanel = getChildAt(i) as UIPanel;
				if(panel){
					panel.onResize();
				}
			}
		}
	}
}