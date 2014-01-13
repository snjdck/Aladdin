package snjdck.g2d.texture
{
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import snjdck.g2d.support.VertexData;
	import snjdck.g2d.core.ITexture2D;

	public class SubTexture2D extends Texture2D
	{
		private const _uvMatrix:Matrix = new Matrix();
		
		private var _parent:ITexture2D;
		private var _region:Rectangle;
		
		public function SubTexture2D(parent:ITexture2D, region:Rectangle=null)
		{
			super(parent ? parent.gpuTexture : null);
			this._parent = parent;
			this._region = region;
		}
		
		public function set parent(value:Texture2D):void
		{
			this._parent = value;
			this.gpuTexture = value.gpuTexture;
		}
		
		public function get region():Rectangle
		{
			return _region;
		}
		
		private function getUvMatrix():Matrix
		{
			if(_region){
				_uvMatrix.setTo(_region.width, 0, 0, _region.height, _region.x, _region.y);
				_uvMatrix.scale(1/_parent.width, 1/_parent.height);
			}else{
				_uvMatrix.identity();
			}
			return _uvMatrix;
		}
		
		override public function adjustVertexData(vertexData:VertexData):void
		{
			super.adjustVertexData(vertexData);
			
			var matrix:Matrix = getUvMatrix();
			
			if(_parent is SubTexture2D){
				matrix.concat((_parent as SubTexture2D).getUvMatrix());
			}
			
			vertexData.transformUV(matrix);
		}
		
		override public function get width():int
		{
			return _region ? _region.width : _parent.width;
		}
		
		override public function get height():int
		{
			return _region ? _region.height : _parent.height;
		}
	}
}