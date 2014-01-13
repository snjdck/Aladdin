package snjdck.g2d.render
{
	import flash.geom.Matrix;
	
	import snjdck.g2d.ns_g2d;
	import snjdck.g2d.core.IDisplayObject2D;
	import snjdck.g2d.core.ITexture2D;
	import snjdck.g2d.support.VertexData;
	
	use namespace ns_g2d;

	final public class DrawUnit2D
	{
		public var next:DrawUnit2D;
		public var child:DrawUnit2D;
		
		public var target:IDisplayObject2D;
		public var texture:ITexture2D;
		
		ns_g2d var index:int;
		ns_g2d var layer:int;
		ns_g2d var z:Number;
		
		public function DrawUnit2D()
		{
		}
		
		public function clear():void
		{
			next = null;
			child = null;
			
			target = null;
			texture = null;
		}
		
		public function getVertexData(vertexData:VertexData):void
		{
			vertexData.reset();
			vertexMatrix.scale(target.width, target.height);
			vertexData.transformPosition(vertexMatrix);
			vertexMatrix.identity();
			vertexData.color = target.color;
			vertexData.alpha = target.worldAlpha;
			texture.adjustVertexData(vertexData);
			vertexData.transformPosition(target.worldMatrix);
			vertexData.z = z;
		}
		
		static private const vertexMatrix:Matrix = new Matrix();
	}
}