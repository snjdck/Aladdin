package Box2D.Collision 
{
	
	/**
	 * Used to warm start b2Distance.
	 * Set count to zero on first call.
	 */
	public class b2SimplexCache 
	{
		/** Length or area */	
		public var metric:Number;		
		public var count:uint;
		/** Vertices on shape a */	
		public const indexA:Vector.<int> = new Vector.<int>(3);	
		/** Vertices on shape b */	
		public const indexB:Vector.<int> = new Vector.<int>(3);	
	}
}