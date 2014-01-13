package snjdck.utils
{
	import flash.net.LocalConnection;

	public class SingleApp
	{
		static private const LC_NAME_1:String = "SingleApp_1";
		static private const LC_NAME_2:String = "SingleApp_2";
		
		static private var lc:LocalConnection;
		private var callback:Function;
		
		public function SingleApp(callback:Function)
		{
			if(null == lc)
			{
				this.callback = callback;
				
				lc = new LocalConnection();
				lc.client = this;
				
				this.init();
			}
		}
		
		private function init():void
		{
			try{
				lc.connect(LC_NAME_1);
			}catch(e:Error){
				lc.connect(LC_NAME_2);
				lc.send(LC_NAME_1, "__close");
			}
		}
		
		public function __close():void
		{
			lc.close();
			lc.send(LC_NAME_2, "__open");
			//
			callback();
		}
		
		public function __open():void
		{
			lc.close();
			lc.connect(LC_NAME_1);
		}
	}
}