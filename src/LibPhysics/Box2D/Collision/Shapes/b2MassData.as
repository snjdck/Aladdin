package Box2D.Collision.Shapes
{
	import Box2D.Common.Math.b2Vec2;
	
	public class b2MassData
	{
		/**
		* The mass of the shape, usually in kilograms.
		*/
		public var mass:Number;
		/**
		* The position of the shape's centroid relative to the shape's origin.
		*/
		public const center:b2Vec2 = new b2Vec2(0, 0);
		/**
		* The rotational inertia of the shape.
		* This may be about the center or local origin, depending on usage.
		*/
		public var I:Number;
		
		public function b2MassData()
		{
			this.mass = 0;
			this.I = 0;
		}
	}
}