package snjdck.ui.scrollable
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.signals.ISignal;
	import flash.signals.Signal;
	
	public class ImageScrollAdapter implements IScrollAdapter
	{
		static private function createMask():DisplayObject
		{
			var sp:Shape = new Shape();
			sp.graphics.beginFill(0);
			sp.graphics.drawRect(0,0,1,1);
			sp.graphics.endFill();
			return sp;
		}
		
		private var image:DisplayObject;
		private var _mask:DisplayObject = createMask();
		private var _pageSizeChangedSignal:Signal = new Signal();
		
		public function ImageScrollAdapter(image:DisplayObject)
		{
			this.image = image;
			_mask.width = image.width;
			_mask.height = image.height;
			image.mask = _mask;
			image.addEventListener(Event.ADDED, __onAdd);
			image.addEventListener(Event.RESIZE, __onResize);
		}
		
		private function __onResize(evt:Event):void
		{
			_pageSizeChangedSignal.notify();
		}
		
		private function __onAdd(evt:Event):void
		{
			if(evt.target != image){
				return;
			}
			image.removeEventListener(Event.ADDED, __onAdd);
			image.addEventListener(Event.REMOVED, __onRemove);
			image.parent.addChild(_mask);
		}
		
		private function __onRemove(evt:Event):void
		{
			if(evt.target != image){
				return;
			}
			image.removeEventListener(Event.REMOVED, __onRemove);
			image.removeEventListener(Event.RESIZE, __onResize);
			image.parent.removeChild(_mask);
		}
		
		public function get displayObject():DisplayObject
		{
			return image;
		}
		
		public function get viewSizeX():Number
		{
			return image.mask.width;
		}

		public function get viewSizeY():Number
		{
			return image.mask.height;
		}
		
		public function get pageSizeX():Number
		{
			return image.width;
		}
		
		public function get pageSizeY():Number
		{
			return image.height;
		}

		public function updateViewX(value:Number):void
		{
			image.x = (viewSizeX - pageSizeX) * value;
		}

		public function updateViewY(value:Number):void
		{
			image.y = (viewSizeY - pageSizeY) * value;
		}
		
		public function updateViewH(value:Number):void
		{
			image.mask.height = value;
		}
		
		public function updateViewW(value:Number):void
		{
			image.mask.width = value;
		}
		
		public function get onPageSizeChanged():ISignal
		{
			return _pageSizeChangedSignal;
		}
	}
}