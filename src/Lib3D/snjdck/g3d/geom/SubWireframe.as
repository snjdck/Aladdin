package snjdck.g3d.geom
{
	import flash.geom.Vector3D;
	
	import array.pushIfNotHas;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.asset.IGpuIndexBuffer;
	import snjdck.g3d.asset.IGpuVertexBuffer;
	import snjdck.g3d.asset.impl.GpuAssetFactory;
	import snjdck.g3d.core.BlendMode;
	import snjdck.g3d.core.Camera3D;
	import snjdck.g3d.render.DrawUnit3D;
//	import snjdck.g3d.render.DrawUnitCollector3D;
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.mesh.SubMesh;
	import snjdck.g3d.parser.IGeometry;
	
	use namespace ns_g3d;

	public class SubWireframe extends Object3D
	{
		private var buffer:Vector.<Number> = new Vector.<Number>();
		private var gpuVertexBuffer:IGpuVertexBuffer;
		private var gpuIndexBuffer:IGpuIndexBuffer;
		
		private var thickness:Number;
		
		public function SubWireframe(subMesh:SubMesh, thickness:Number=1)
		{
			this.thickness = thickness * 0.5;
			generate(subMesh.geometry);
		}
		/*
		override ns_g3d function collectDrawUnit(collector:DrawUnitCollector3D, camera:Camera3D):void
		{
			super.collectDrawUnit(collector, camera);
			
			var drawUnit:DrawUnit3D = collector.getFreeDrawUnit();
			
			drawUnit.setWorldMatrix(worldMatrix);
			drawUnit.setVcM(8, camera.worldMatrix);
			drawUnit.setVc(12, new<Number>[
				0, 0, 1, thickness
			], 1);
			drawUnit.setFc(1, new<Number>[
				0, 1, 0, 0.5
			], 1);
			
			drawUnit.setVa2(gpuVertexBuffer, [3, 4]);
			
			drawUnit.blendFactor = BlendMode.ALPHAL;
			drawUnit.shaderName = "object_wireframe";
			
			drawUnit.indexBuffer = gpuIndexBuffer;
			
			collector.addDrawUnit(drawUnit);
		}
		*/
		private function generate(geometry:IGeometry):void
		{
			var indexBuffer:Vector.<uint> = geometry.getIndexData();
			for(var i:int=0, n:int=indexBuffer.length; i<n; i+=3)
			{
				var a:uint = indexBuffer[i];
				var b:uint = indexBuffer[i+1];
				var c:uint = indexBuffer[i+2];
				
				addSegment(geometry, a, b);
				addSegment(geometry, a, c);
				addSegment(geometry, b, c);
			}
			gpuVertexBuffer = GpuAssetFactory.CreateGpuVertexBuffer(buffer, buffer.length/(usedList.length*4));
			gpuIndexBuffer = GpuAssetFactory.CreateQuadBuffer(usedList.length);
		}
		
		private var usedList:Array = [];
		
		private function addSegment(geometry:IGeometry, vertexIndex1:uint, vertexIndex2:uint):void
		{
			var min:uint = Math.min(vertexIndex1, vertexIndex2);
			var max:uint = Math.max(vertexIndex1, vertexIndex2);
			
			if(array.pushIfNotHas(usedList, (min << 16 | max)))
			{
				var v1:Vector3D = new Vector3D();
				var v2:Vector3D = new Vector3D();
				
				geometry.getVertex(vertexIndex1, v1);
				geometry.getVertex(vertexIndex2, v2);
				
				var v3:Vector3D = v2.subtract(v1);
				v3.normalize();
				
				buffer.push(v1.x, v1.y, v1.z, v3.x, v3.y, v3.z, 1);
				buffer.push(v1.x, v1.y, v1.z, v3.x, v3.y, v3.z, -1);
				
				v3.negate();
				
				buffer.push(v2.x, v2.y, v2.z, v3.x, v3.y, v3.z, 1);
				buffer.push(v2.x, v2.y, v2.z, v3.x, v3.y, v3.z, -1);
			}
			
		}
	}
}