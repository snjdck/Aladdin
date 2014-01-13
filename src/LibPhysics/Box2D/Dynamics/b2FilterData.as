package Box2D.Dynamics
{
	/**
	* This holds contact filtering data.
	*/
	final public class b2FilterData
	{
		/**
		* The collision category bits. Normally you would just set one bit.
		*/
		public var categoryBits:uint;
	
		/**
		* The collision mask bits. This states the categories that this
		* shape would accept for collision.
		*/
		public var maskBits:uint;
	
		/**
		* Collision groups allow a certain group of objects to never collide (negative)
		* or always collide (positive). Zero means no collision group. Non-zero group
		* filtering always wins against the mask bits.
		*/
		public var groupIndex:int;
		
		public function b2FilterData()
		{
			categoryBits = 0x0001;
			maskBits = 0xFFFF;
			groupIndex = 0;
		}
		
		public function Copy():b2FilterData
		{
			var copy:b2FilterData = new b2FilterData();
			copy.categoryBits = categoryBits;
			copy.maskBits = maskBits;
			copy.groupIndex = groupIndex;
			return copy;
		}
	}
}