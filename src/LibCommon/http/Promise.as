package http
{
	import lambda.call;
	import flash.lang.ICloseable;

	final internal class Promise implements ICloseable
	{
		private var ldr:*;
		private var handler:Object;
		
		public function Promise(ldr:Object, handler:Object)
		{
			this.ldr = ldr;
			this.handler = handler;
		}
		
		internal function notify(ok:Boolean, data:*):void
		{
			notifyImp(ok, data);
		}
		
		public function close():void
		{
			if(ldr)
			{
				ldr.close();
				notifyImp(false, "stream has closed by 'close()' method!");
			}
		}
		
		private function notifyImp(ok:Boolean, data:*):void
		{
			ldr = null;
			lambda.call(handler, ok, data);
			handler = null;
		}
	}
}