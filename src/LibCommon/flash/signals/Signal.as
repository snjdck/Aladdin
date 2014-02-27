package flash.signals
{
	import flash.utils.Dictionary;
	
	import dict.deleteKey;
	import dict.hasKey;
	
	import lambda.apply;

	public class Signal implements ISignal
	{
		private var paramTypes:Array;
		private var handlerMap:Object;
		
		public function Signal(...paramTypes)
		{
			checkArgTypes(paramTypes);
			this.paramTypes = paramTypes;
			this.handlerMap = new Dictionary();
		}
		
		public function notify(...args):void
		{
			checkArgs(args);
			for(var handler:* in handlerMap){
				lambda.apply(handler, args);
				if(handlerMap[handler]){//只监听一次,自动删除
					del(handler);
				}
			}
		}
		
		public function add(handler:Function, once:Boolean=false):void
		{
			handlerMap[handler] = once;
		}
		
		public function del(handler:Function):void
		{
			dict.deleteKey(handlerMap, handler);
		}
		
		public function has(handler:Function):Boolean
		{
			return dict.hasKey(handlerMap, handler);
		}
		
		private function checkArgTypes(argTypes:Array):void
		{
			for each(var type:* in argTypes){
				if(!(type is Class)){
					throw new ArgumentError("argType must be Class!");
				}
			}
		}
		
		private function checkArgs(args:Array):void
		{
			if(args.length != paramTypes.length){
				throw new ArgumentError("arg length is not fit with argTypes!");
			}
			
			for(var i:int=0, n:int=paramTypes.length; i<n; i++){
				var arg:Object = args[i];
				if(arg && !(arg is paramTypes[i])){
					throw new ArgumentError("arg " + i + "type error! it must be " + paramTypes[i]);
				}
			}
		}
	}
}