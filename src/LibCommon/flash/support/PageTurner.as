package flash.support
{
	import flash.signals.Signal;
	
	import math.truncate;
	
	final public class PageTurner
	{
		public const pageChangedSignal:Signal = new Signal();
		
		private var _source:Array;
		private var _limit:int;
		private var _pageIndex:int;
		private var _adjustContent:Boolean;
		
		public function PageTurner(limit:int, adjustContent:Boolean=false)
		{
			_source = [];
			_limit = Math.max(limit, 1);
			_pageIndex = 1;
			_adjustContent = adjustContent;
		}
		
		public function get source():Array
		{
			return _source;
		}
		
		public function set source(list:Array):void
		{
			if(null == list){
				list = [];
			}
			
			if(_adjustContent){
				if(list.length > 0){
					var n:int = Math.ceil(list.length / limit) * limit;
					if(list.length < n){
						list.length = n;
					}
				}else{
					list.length = limit;
				}
			}
			
			_source = list;
			gotoFirstPage();
		}
		
		public function get limit():int
		{
			return _limit;
		}
		
		public function get totalPages():int
		{
			if(source.length <= 0){
				return 1;
			}
			return Math.ceil(source.length / limit);
		}
		
		public function get pageIndex():int
		{
			return _pageIndex;
		}
		
		public function set pageIndex(value:int):void
		{
			_pageIndex = truncate(value, 1, totalPages);
			pageChangedSignal.notify();
		}
		
		public function getCurrentPageData():Array
		{
			return source.slice(
				limit * (pageIndex-1),
				limit * pageIndex
			);
		}
		
		public function gotoPrevPage():void
		{
			--pageIndex;
		}
		
		public function gotoNextPage():void
		{
			++pageIndex;
		}
		
		public function gotoFirstPage():void
		{
			pageIndex = 1;
		}
		
		public function gotoLastPage():void
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
	}
}