package snjdck.utils
{
	import flash.events.Event;
	
	import math.truncate;
	

	public class PageTurner
	{
		private var _source:Array;
		private var _limit:int;
		private var callback:Function;
		private var _pageIndex:int;
		
		public function PageTurner(callback:Function, limit:int)
		{
			this._source = [];
			this._limit = Math.max(limit, 1);
			this.callback = callback;
			this._pageIndex = 1;
		}
		
		public function get source():Array
		{
			return this._source;
		}
		
		public function get limit():int
		{
			return this._limit;
		}
		
		public function get totalPages():int
		{
			if(source.length > 0){
				return Math.ceil(source.length / limit);
			}
			return 1;
		}
		
		public function get pageIndex():int
		{
			return this._pageIndex;
		}
		
		public function set pageIndex(value:int):void
		{
			var newValue:int = truncate(value, 1, totalPages);
			
			if(pageIndex != newValue){
				setPageIndex(newValue);
			}
		}
		
		private function setPageIndex(val:int):void
		{
			this._pageIndex = val;
			callback(source.slice((pageIndex-1)*limit, pageIndex*limit));
		}
		
		public function setSource(list:Array, adjustContent:Boolean=false):void
		{
			if(null == list){
				list = [];
			}
			
			if(adjustContent){
				if(list.length > 0){
					var n:int = Math.ceil(list.length / limit) * limit;
					if(list.length < n){
						list.length = n;
					}
				}else{
					list.length = limit;
				}
			}
			
			this._source = list;
			setPageIndex(1);
		}
		
		public function notifySourceChanged():void
		{
			setPageIndex(1);
		}
		
		public function prevPage():void
		{
			--pageIndex;
		}
		
		public function nextPage():void
		{
			++pageIndex;
		}
		
		public function firstPage():void
		{
			pageIndex = 1;
		}
		
		public function lastPage():void
		{
			pageIndex = totalPages;
		}
		
		public function hasPrevPage():Boolean
		{
			return pageIndex > 1;
		}
		
		public function hasNextPage():Boolean
		{
			return pageIndex < totalPages;
		}
		
		public function hasMultiPages():Boolean
		{
			return totalPages > 1;
		}
		
		final public function prevPageEventHandler(evt:Event):void{
			prevPage();
		}
		
		final public function nextPageEventHandler(evt:Event):void{
			nextPage();
		}
		
		final public function firstPageEventHandler(evt:Event):void{
			firstPage();
		}
		
		final public function lastPageEventHandler(evt:Event):void{
			lastPage();
		}
	}
}