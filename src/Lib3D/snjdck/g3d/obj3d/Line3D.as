package snjdck.g3d.obj3d
{
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Vector3D;
	import flash.geom.d3.createMeshIndices;
	import flash.utils.Vector3DUtil;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.core.Camera3D;
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.parser.Geometry;
	import snjdck.g3d.render.DrawUnitCollector3D;
	import snjdck.g3d.render.IDrawUnit3D;
	import snjdck.gpu.BlendMode;
	import snjdck.gpu.GpuColor;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuIndexBuffer;
	import snjdck.gpu.asset.GpuVertexBuffer;
	
	use namespace ns_g3d;
	
	public class Line3D extends Object3D implements IDrawUnit3D
	{
		private var vertexBuffer:GpuVertexBuffer;
		private var indexBuffer:GpuIndexBuffer;
		
		public const color:GpuColor = new GpuColor(0xFFFFFFFF);
		public var lineWidth:Number = 1;
		
		private var canRender:Boolean;
		
		public function Line3D()
		{
			blendMode = BlendMode.NORMAL;
			vertexBuffer = new GpuVertexBuffer(4, 6);
			var indices:Vector.<uint> = new Vector.<uint>();
			createMeshIndices(2, 2, indices);
			indexBuffer = new GpuIndexBuffer(6);
			indexBuffer.upload(indices);
		}
		
		private const v:Vector.<Number> = new Vector.<Number>(24, true);
		
		public function setPt(from:Vector3D, to:Vector3D):void
		{
			Vector3DUtil.CopyTo(from, v);
			Vector3DUtil.CopyTo(from, v, 6);
			Vector3DUtil.CopyTo(to, v, 12);
			Vector3DUtil.CopyTo(to, v, 18);
			var dir:Vector3D = to.subtract(from);
			dir.normalize();
			Vector3DUtil.CopyTo(dir, v, 3);
			Vector3DUtil.CopyTo(dir, v, 15);
			dir.negate();
			Vector3DUtil.CopyTo(dir, v, 9);
			Vector3DUtil.CopyTo(dir, v, 21);
			vertexBuffer.upload(v);
			canRender = true;
		}
		
		public function draw(context3d:GpuContext, camera3d:Camera3D):void
		{
			context3d.setVcM(Geometry.WORLD_MATRIX_OFFSET, prevWorldMatrix);
			camera3d.getCameraZ(zAxis);
			Vector3DUtil.CopyTo(zAxis, buffer);
			buffer[3] = lineWidth * 0.5;
			context3d.setVc(8, buffer);
			color.copyTo(buffer);
			context3d.setFc(0, buffer);
			
			context3d.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			context3d.setVertexBufferAt(1, vertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_3);
			context3d.drawTriangles(indexBuffer);
		}
		
		static private const zAxis:Vector3D = new Vector3D();
		static private const buffer:Vector.<Number> = new Vector.<Number>(4, true);
		
		public function get shaderName():String
		{
			return "line3d";
		}
		
		override ns_g3d function collectDrawUnit(collector:DrawUnitCollector3D, camera3d:Camera3D):void
		{
			if(canRender){
				collector.addDrawUnit(this);
			}
		}
	}
}