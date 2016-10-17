package snjdck.g3d.rendersystem.subsystems
{
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DTriangleFace;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Matrix3D;
	import flash.geom.d3.createQuadListIndices;
	
	import snjdck.g3d.parser.Geometry;
	import snjdck.g3d.rendersystem.ISystem;
	import snjdck.g3d.terrain.TerrainQuad;
	import snjdck.gpu.BlendMode;
	import snjdck.gpu.asset.AssetMgr;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuIndexBuffer;
	import snjdck.gpu.asset.GpuVertexBuffer;
	import snjdck.shader.ShaderName;
	
	internal class TerrainRender implements ISystem
	{
		static private const COUNT_PER_VERTEX:int = 3;
		
		static private const worldMatrix:Matrix3D = new Matrix3D();
		
		private var vertexBuffer:GpuVertexBuffer;
		private var indexBuffer:GpuIndexBuffer;
		
		private var geometryShaderName:String;
		private var depthShaderName:String;
		private var depthCubeShaderName:String;
		
		public function TerrainRender()
		{
			geometryShaderName = ShaderName.TERRAIN + "_geom";
			depthShaderName = ShaderName.TERRAIN + "_depth";
			depthCubeShaderName = ShaderName.TERRAIN + "_depth_cube";
			
			var vertexData:Vector.<Number> = new Vector.<Number>(4 * COUNT_PER_VERTEX);
			var offset:int = 0;
			offset += COUNT_PER_VERTEX;
			vertexData[offset  ] = 1;
			vertexData[offset+2] = 1;
			offset += COUNT_PER_VERTEX;
			vertexData[offset+1] = 1;
			vertexData[offset+2] = 2;
			offset += COUNT_PER_VERTEX;
			vertexData[offset  ] = 1;
			vertexData[offset+1] = 1;
			vertexData[offset+2] = 3;
			vertexBuffer = new GpuVertexBuffer(4, COUNT_PER_VERTEX);
			vertexBuffer.upload(vertexData);
			
			var indexData:Vector.<uint> = new Vector.<uint>();
			createQuadListIndices(1, indexData);
			indexBuffer = new GpuIndexBuffer(indexData.length);
			indexBuffer.upload(indexData);
		}
		
		public function activePass(context3d:GpuContext, passIndex:int):void
		{
			context3d.setDepthTest(true, Context3DCompareMode.LESS_EQUAL);
			context3d.blendMode = BlendMode.NORMAL;
			context3d.setCulling(Context3DTriangleFace.BACK);
			
			context3d.setVcM(Geometry.WORLD_MATRIX_OFFSET, worldMatrix);
			context3d.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			
			if(passIndex == RenderPass.MATERIAL_PASS){
				context3d.program = AssetMgr.Instance.getProgram(ShaderName.TERRAIN);
				context3d.setVertexBufferAt(1, vertexBuffer, 2, Context3DVertexBufferFormat.FLOAT_1);
			}else if(passIndex == RenderPass.GEOMETRY_PASS){
				context3d.program = AssetMgr.Instance.getProgram(geometryShaderName);
			}else if(passIndex == RenderPass.DEPTH_PASS){
				context3d.program = AssetMgr.Instance.getProgram(depthShaderName);
			}else if(passIndex == RenderPass.DEPTH_CUBE_PASS){
				context3d.program = AssetMgr.Instance.getProgram(depthCubeShaderName);
			}
		}
		
		public function render(context3d:GpuContext, item:Object):void
		{
			var quad:TerrainQuad = item as TerrainQuad;
			if(context3d.isFsSlotInUse(0)){
				context3d.setTextureAt(0, quad.tex0);
				context3d.setTextureAt(1, quad.tex1);
			}
			context3d.setVc(Geometry.BONE_MATRIX_OFFSET, quad.vcConst);
//			context3d.setFc(0, quad.fcConst);
			context3d.drawTriangles(indexBuffer);
		}
	}
}