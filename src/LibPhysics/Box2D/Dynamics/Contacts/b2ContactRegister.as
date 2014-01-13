package Box2D.Dynamics.Contacts
{
	/**
	* @private
	*/
	public class b2ContactRegister
	{
		public var createFcn:Function; // fcn pointer
		public var destroyFcn:Function;// fcn pointer
		
		public var primary:Boolean;
		public var pool:b2Contact;
		public var poolCount:int;
		
		public function b2ContactRegister()
		{
			
		}
	}
}