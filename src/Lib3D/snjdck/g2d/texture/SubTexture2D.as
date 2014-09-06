package snjdck.g2d.texture
{
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import snjdck.g2d.core.ITexture2D;

	public class SubTexture2D extends Texture2D
	{
		private var _parent:ITexture2D;
		protected var _frame:Rectangle;
		private var _region:Rectangle;
		
		public function SubTexture2D(parent:ITexture2D, region:Rectangle=null)
		{
			super(parent ? parent.gpuTexture : null);
			this._parent = parent;
			this._region = region;
			
			var matrix:Matrix = getUvMatrix();
			
			if(_parent is SubTexture2D){
				matrix.concat((_parent as SubTexture2D).getUvMatrix());
			}
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
		
		override public function get width():int
		{
			if(_frame != null){
				return _frame.width;
			}
			return _region ? _region.width : _parent.width;
		}
		
		override public function get height():int
		{
			if(_frame != null){
				return _frame.height;
			}
			return _region ? _region.height : _parent.height;
		}
		
		public function get frame():Rectangle
		{
			return _frame;
		}
		
		public function set frame(val:Rectangle):void
		{
			_frame = val;
			
			if(null == _frame){
				_frameMatrix.identity();
				return;
			}
			
			_frameMatrix.a = region.width / _frame.width;
			_frameMatrix.d = region.height / _frame.height;
			_frameMatrix.tx = -frame.x;
			_frameMatrix.ty = -frame.y;
		}
	}
}