package snjdck.g3d.terrain
{
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import snjdck.g3d.parser.Geometry;
	import snjdck.gpu.GpuColor;
	import snjdck.gpu.asset.AssetMgr;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuVertexBuffer;
	import snjdck.gpu.asset.IGpuTexture;
	import snjdck.gpu.support.QuadRender;
	import snjdck.quadtree.IQuadTreeNode;

	public class TerrainQuad implements IQuadTreeNode
	{
//		static private const COUNT_PER_VERTEX:int = 7;
//		private var vertexData:Vector.<Number>;
		
		public var tex0:IGpuTexture;
		public var tex1:IGpuTexture;
		
		public var alpha:Number;
		public var light:GpuColor = new GpuColor();
		
//		public var vertexBuffer:GpuVertexBuffer;
		
		public function TerrainQuad()
		{
//			vertexData = new Vector.<Number>(4 * COUNT_PER_VERTEX);
//			vertexBuffer = new GpuVertexBuffer(4, COUNT_PER_VERTEX);
			worldMatrix.appendScale(128, 128, 1);
		}
		
		public function setLight(value:uint):void
		{
			light.value = value;
		}
		/*
		public function setValue(vertexIndex:int, x:Number, y:Number, z:Number, u:Number, v:Number, light:Number, blend:Number):void
		{
			var offset:int = vertexIndex * COUNT_PER_VERTEX;
			vertexData[offset++] = x;
			vertexData[offset++] = y;
			vertexData[offset++] = z;
			vertexData[offset++] = u;
			vertexData[offset++] = v;
			vertexData[offset++] = light;
			vertexData[offset] = blend;
		}
		*/
		private const worldMatrix:Matrix3D = new Matrix3D();
		private const position:Vector3D = new Vector3D();
		
		public function draw(context3d:GpuContext):void
		{
//			vertexBuffer.upload(vertexData);
			
			context3d.setVcM(Geometry.WORLD_MATRIX_OFFSET, worldMatrix);
			
			/*
			context3d.setTextureAt(0, AssetMgr.Instance.getTexture("terrain"));
			context3d.setTextureAt(1, AssetMgr.Instance.getTexture("terrain"));
			context3d.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			context3d.setVertexBufferAt(1, vertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_4);
			*/
			QuadRender.Instance.drawTriangles(context3d);
		}
		
		public function get height():Number
		{
			return 128;
		}
		
		public function get width():Number
		{
			return 128;
		}
		
		public function get x():Number
		{
			return position.x;
		}
		
		public function get y():Number
		{
			return position.y;
		}
		
		public function set x(value:Number):void
		{
			position.x = value;
			worldMatrix.position = position;
		}
		
		public function set y(value:Number):void
		{
			position.y = value;
			worldMatrix.position = position;
		}
	}
}