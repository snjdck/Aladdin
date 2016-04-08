package flash.rx
{
	public class Observer
	{
		private const handlerList:Array = [];
		private const itemList:Array = [];
		
		public function Observer()
		{
		}
		
		public function onNext(value:Object):void
		{
			itemList.push(value);
			for each(var handler:Function in handlerList){
				handler(value);
			}
		}
		
		public function subscribeNext(handler:Function):void
		{
			if(handlerList.indexOf(handler) < 0){
				handlerList.push(handler);
			}
		}
		
		public function filter(handler:Function):Observer
		{
			var other:Observer = new Observer();
			for each(var item:Object in itemList){
				if(handler(item)){
					other.itemList.push(item);
				}
			}
			subscribeNext(function(value:Object):void{
				if(handler(value)){
					other.onNext(value);
				}
			});
			return other;
		}
		
		public function map(handler:Function):Observer
		{
			var other:Observer = new Observer();
			for each(var item:Object in itemList){
				other.itemList.push(handler(item));
			}
			subscribeNext(function(value:Object):void{
				other.onNext(handler(value));
			});
			return other;
		}
		
		public function forEach(handler:Function):Observer
		{
			for each(var item:Object in itemList){
				handler(item);
			}
			return this;
		}
		
		public function skip(count:int):Observer
		{
			var other:Observer = new Observer();
			for(var i:int=count, n:int=itemList.length; i<n; ++i){
				other.itemList.push(itemList[i]);
			}
			subscribeNext(function(value:Object):void{
				if(itemList.length > count){
					other.onNext(value);
				}
			});
			return other;
		}
		
		public function take(count:int):Observer
		{
			var other:Observer = new Observer();
			for(var i:int=0; i<count; ++i){
				if(i < itemList.length){
					other.itemList.push(itemList[i]);
				}
			}
			subscribeNext(function(value:Object):void{
				if(other.itemList.length < count){
					other.onNext(value);
				}
			});
			return other;
		}
	}
}