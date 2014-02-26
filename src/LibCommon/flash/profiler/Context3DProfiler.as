package flash.profiler
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.textures.Texture;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	public class Context3DProfiler extends Sprite
	{
		private var stage3d:Stage3D;
		private var context3d:Context3D;
		
		public function Context3DProfiler()
		{
			prepareData();
			stage3d = stage.stage3Ds[0];
			stage3d.addEventListener(Event.CONTEXT3D_CREATE, __onCreate);
			stage3d.requestContext3D();
		}
		
		private var vertexBuffer:VertexBuffer3D;
		private var vertexBufferData:Vector.<Number>;
		private var numVertices:int = 10000;
		private var data32PerVertex:int = 12;
		
		private var indexBuffer:IndexBuffer3D;
		private var indexBufferData:Vector.<uint>;
		private var numIndices:int = 7000;
		
		private var texture:Texture;
		private var textureData:BitmapData;
		private var bmdWidth:int = 2048;
		private var bmdHeight:int = 2048;
		
		private function prepareData():void
		{
			vertexBufferData = new Vector.<Number>(numVertices * data32PerVertex);
			indexBufferData = new Vector.<uint>(numIndices);
			textureData = new BitmapData(bmdWidth, bmdHeight, true);
		}
		
		private function testVertexBuffer():void
		{
			vertexBuffer = context3d.createVertexBuffer(numVertices, data32PerVertex);
			vertexBuffer.uploadFromVector(vertexBufferData, 0, numVertices);
			vertexBuffer.dispose();
		}
		
		private function testIndexBuffer():void
		{
			indexBuffer = context3d.createIndexBuffer(numIndices);
			indexBuffer.uploadFromVector(indexBufferData, 0, numIndices);
			indexBuffer.dispose();
		}
		
		private function testTexture():void
		{
			texture = context3d.createTexture(bmdWidth, bmdHeight, Context3DTextureFormat.BGRA, false);
			texture.uploadFromBitmapData(textureData);
			texture.dispose();
		}
		
		private function __onCreate(evt:Event):void
		{
			context3d = stage3d.context3D;
			context3d.configureBackBuffer(stage.stageWidth, stage.stageHeight, 4);
//			context3d.enableErrorChecking = true;
			trace(context3d.driverInfo);
			
			trace("vertex", calcFuncExecTime(testVertexBuffer));
			trace("index", calcFuncExecTime(testIndexBuffer));
			trace("texture", calcFuncExecTime(testTexture));
		}
	}
}