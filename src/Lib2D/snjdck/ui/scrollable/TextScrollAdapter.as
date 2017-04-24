package snjdck.ui.scrollable
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.signals.ISignal;
	import flash.signals.Signal;
	import flash.text.TextField;
	
	public class TextScrollAdapter implements IScrollAdapter
	{
		private var textField:TextField;
		private var _pageSizeChangedSignal:Signal = new Signal();
		private var _pageSize:int;
		
		public function TextScrollAdapter(textField:TextField)
		{
			this.textField = textField;
			textField.addEventListener(Event.CHANGE, __onTextChanged);
			_pageSize = pageSizeY;
		}
		
		public function get displayObject():DisplayObject
		{
			return textField;
		}
		
		public function get viewSizeX():Number
		{
			return textField.width;
		}

		public function get viewSizeY():Number
		{
			return textField.bottomScrollV - textField.scrollV + 1;
		}
		
		public function get pageSizeX():Number
		{
			return textField.textWidth;
		}

		public function get pageSizeY():Number
		{
			return textField.numLines;
		}
		
		private function __onTextChanged(evt:Event):void
		{
			if(_pageSize != pageSizeY){
				_pageSize = pageSizeY;
				_pageSizeChangedSignal.notify();
			}
		}
		
		public function get onPageSizeChanged():ISignal
		{
			return _pageSizeChangedSignal;
		}
		
		public function updateViewH(value:Number):void
		{
			textField.height = value;
		}
		
		public function updateViewW(value:Number):void
		{
			textField.width = value;
		}
		
		public function updateViewX(value:Number):void
		{
			textField.scrollH = textField.maxScrollH * value;
		}
		
		public function updateViewY(value:Number):void
		{
			var newValue:int = 1 + (textField.maxScrollV - 1) * value;
			if(textField.scrollV != newValue){
				textField.scrollV = newValue;
			}
		}
	}
}