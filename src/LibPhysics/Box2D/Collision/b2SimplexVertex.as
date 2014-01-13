package Box2D.Collision 
{
	import Box2D.Common.Math.b2Vec2;
	
	internal class b2SimplexVertex
	{
		public function Set(other:b2SimplexVertex):void
		{
			wA.SetV(other.wA);
			wB.SetV(other.wB);
			w.SetV(other.w);
			a = other.a;
			indexA = other.indexA;
			indexB = other.indexB;
		}
		
		public var wA:b2Vec2;		// support point in proxyA
		public var wB:b2Vec2;		// support point in proxyB
		public var w:b2Vec2;		// wB - wA
		public var a:Number;		// barycentric coordinate for closest point
		public var indexA:int;	// wA index
		public var indexB:int;	// wB index
	}
	
}