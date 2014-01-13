package Box2D.Collision 
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Common.b2Settings;
	import Box2D.Common.b2internal;
	import Box2D.Common.Math.b2Vec2;
	
	use namespace b2internal;

	/**
	 * A distance proxy is used by the GJK algorithm.
 	 * It encapsulates any shape.
 	 */
	public class b2DistanceProxy 
	{
 		/**
 		 * Initialize the proxy using the given shape. The shape
 		 * must remain in scope while the proxy is in use.
 		 */
 		public function Set(shape:b2Shape):void
		{
			switch(shape.GetType())
			{
				case b2Shape.e_circleShape:
				{
					var circle:b2CircleShape = shape as b2CircleShape;
					m_vertices = new Vector.<b2Vec2>(1, true);
					m_vertices[0] = circle.m_p;
					m_count = 1;
					m_radius = circle.m_radius;
				}
				break;
				case b2Shape.e_polygonShape:
				{
					var polygon:b2PolygonShape =  shape as b2PolygonShape;
					m_vertices = polygon.m_vertices;
					m_count = polygon.m_vertexCount;
					m_radius = polygon.m_radius;
				}
				break;
				default:
					b2Settings.b2Assert(false);
			}
		}
		
 		/**
 		 * Get the supporting vertex index in the given direction.
 		 */
 		public function GetSupport(d:b2Vec2):Number
		{
			var bestIndex:int = 0;
			var bestValue:Number = m_vertices[0].x * d.x + m_vertices[0].y * d.y;
			for (var i:int= 1; i < m_count; ++i)
			{
				var value:Number = m_vertices[i].x * d.x + m_vertices[i].y * d.y;
				if (value > bestValue)
				{
					bestIndex = i;
					bestValue = value;
				}
			}
			return bestIndex;
		}
		
 		/**
 		 * Get the supporting vertex in the given direction.
 		 */
 		public function GetSupportVertex(d:b2Vec2):b2Vec2
		{
			var bestIndex:int = 0;
			var bestValue:Number = m_vertices[0].x * d.x + m_vertices[0].y * d.y;
			for (var i:int= 1; i < m_count; ++i)
			{
				var value:Number = m_vertices[i].x * d.x + m_vertices[i].y * d.y;
				if (value > bestValue)
				{
					bestIndex = i;
					bestValue = value;
				}
			}
			return m_vertices[bestIndex];
		}
 		/**
 		 * Get the vertex count.
 		 */
 		public function GetVertexCount():int
		{
			return m_count;
		}
		
 		/**
 		 * Get a vertex by index. Used by b2Distance.
 		 */
 		public function GetVertex(index:int):b2Vec2
		{
			b2Settings.b2Assert(0 <= index && index < m_count);
			return m_vertices[index];
		}
		
 		public var m_vertices:Vector.<b2Vec2>;
 		public var m_count:int;
 		public var m_radius:Number;
	}
}