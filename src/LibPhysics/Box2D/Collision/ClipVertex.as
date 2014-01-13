package Box2D.Collision
{
	import Box2D.Common.Math.b2Vec2;
		
	/**
	* @private
	*/
	public class ClipVertex
	{
		public function Set(other:ClipVertex):void
		{
			v.SetV(other.v);
			id.Set(other.id);
		}
		
		public const v:b2Vec2 = new b2Vec2();
		public var id:b2ContactID = new b2ContactID();
	}
}