package snjdck.g3d.terrain
{
	import flash.display.BitmapData;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Vector3D;
	
	import snjdck.g3d.bounds.AABB;
	import snjdck.g3d.parser.Geometry;
	import snjdck.gpu.GpuColor;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuVertexBuffer;
	import snjdck.gpu.asset.IGpuTexture;
	import snjdck.quadtree.IQuadTreeItem;

	public class TerrainQuad implements IQuadTreeItem
	{
		public var tex0:IGpuTexture;
		public var tex1:IGpuTexture;
		
		public var light:GpuColor = new GpuColor();
		
		public const vcConst:Vector.<Number> = new Vector.<Number>(24);
//		public const fcConst:Vector.<Number> = new Vector.<Number>(4);
		
		private const aabb:AABB = new AABB();
		
		private var terrain:Terrain;
		
		public function TerrainQuad(terrain:Terrain)
		{
			this.terrain = terrain;
			aabb.halfSize.setTo(width >> 1, height >> 1, 0);
		}
		
		public function setLight(value:uint):void
		{
			
		}
		//*
		public function setValue(dx:int, dy:int, alphaData:Array, lightData:BitmapData):void
		{
			var u:Number = (dx & 3) * 0.25;
			var v:Number = (dy & 3) * 0.25;
			
			vcConst[0] = dx * width;
			vcConst[1] = - dy * height;
			vcConst[2] = width;
			vcConst[3] = 1;
			
			vcConst[4] = u;
			vcConst[5] = v;
			vcConst[6] = 0.25;
			
			light.value = lightData.getPixel32(dx, dy+1);
			light.copyTo(vcConst, 8);
			light.value = lightData.getPixel32(dx+1, dy+1);
			light.copyTo(vcConst, 12);
			light.value = lightData.getPixel32(dx, dy);
			light.copyTo(vcConst, 16);
			light.value = lightData.getPixel32(dx+1, dy);
			light.copyTo(vcConst, 20);
			
			vcConst[11] = alphaData[(dx)|((dy+1)<<8)] / 0xFF;
			vcConst[15] = alphaData[(dx+1)|((dy+1)<<8)] / 0xFF;
			vcConst[19] = alphaData[(dx)|((dy)<<8)] / 0xFF;
			vcConst[23] = alphaData[(dx+1)|((dy+1)<<8)] / 0xFF;
			
//			vcConst[11] = 1 - vcConst[11];
//			vcConst[15] = 1 - vcConst[15];
//			vcConst[19] = 1 - vcConst[19];
//			vcConst[23] = 1 - vcConst[23];
			
			
//			fcConst[3] = blend;
			
			aabb.center.setTo(x + aabb.halfSize.x, y + aabb.halfSize.y, 0);
			/*
			var offset:int = 0;
			vertexData[offset  ] = x;
			vertexData[offset+1] = y;
			vertexData[offset+2] = 0;
			vertexData[offset+3] = u;
			vertexData[offset+4] = v;
			vertexData[offset+5] = light;
			vertexData[offset+6] = blend;
			offset += COUNT_PER_VERTEX;
			vertexData[offset  ] = x + width;
			vertexData[offset+1] = y;
			vertexData[offset+2] = 0;
			vertexData[offset+3] = u + 0.25;
			vertexData[offset+4] = v;
			vertexData[offset+5] = light;
			vertexData[offset+6] = blend;
			offset += COUNT_PER_VERTEX;
			vertexData[offset  ] = x;
			vertexData[offset+1] = y + height;
			vertexData[offset+2] = 0;
			vertexData[offset+3] = u;
			vertexData[offset+4] = v + 0.25;
			vertexData[offset+5] = light;
			vertexData[offset+6] = blend;
			offset += COUNT_PER_VERTEX;
			vertexData[offset  ] = x + width;
			vertexData[offset+1] = y + height;
			vertexData[offset+2] = 0;
			vertexData[offset+3] = u + 0.25;
			vertexData[offset+4] = v + 0.25;
			vertexData[offset+5] = light;
			vertexData[offset+6] = blend;
			offset += COUNT_PER_VERTEX;
			
			vertexBuffer.upload(vertexData);
			*/
		}
		/*
		public function uploadVertexData(context3d:GpuContext):void
		{
			context3d.setVc(Geometry.BONE_MATRIX_OFFSET, vcConst);
			context3d.setFc(0, fcConst);
//			context3d.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
//			context3d.setVertexBufferAt(1, vertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_4);
		}
		*/
		public function get height():Number
		{
			return 100;
		}
		
		public function get width():Number
		{
			return 100;
		}
		
		public function get x():Number
		{
			return vcConst[0];
		}
		
		public function get y():Number
		{
			return vcConst[1];
		}
		
		public function getBound():AABB
		{
			return aabb;
		}
	}
}