package snjdck.g2d.impl
{
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import snjdck.g2d.core.ITexture2D;
	import snjdck.gpu.asset.IGpuTexture;

	public class Texture2D implements ITexture2D
	{
		private var _width:int;
		private var _height:int;
		
		private var _gpuTexture:IGpuTexture;
		
		private var hasFrame:Boolean;
		private const _frameMatrix:Matrix = new Matrix();
		
		private var hasRegion:Boolean;
		private const _regionMatrix:Matrix = new Matrix();
		
		private var _scale9:Vector.<Number>;
		
		public function Texture2D(gpuTexture:IGpuTexture=null)
		{
			this.gpuTexture = gpuTexture;
		}
		
		public function get gpuTexture():IGpuTexture
		{
			return _gpuTexture;
		}
		
		public function set gpuTexture(value:IGpuTexture):void
		{
			if(hasFrame){
				_frameMatrix.identity();
				hasFrame = false;
			}
			if(hasRegion){
				_regionMatrix.identity();
				hasRegion = false;
			}
			if(value != null){
				_width = value.width;
				_height = value.height;
			}else{
				_width = 0;
				_height = 0;
			}
			_gpuTexture = value;
		}
		
		public function set frame(value:Rectangle):void
		{
			assert(!hasFrame, "frame can't be set twice!");
			hasFrame = (value != null);
			if(hasFrame){
				_frameMatrix.a = _width / value.width;
				_frameMatrix.d = _height / value.height;
				_frameMatrix.tx = -value.x;
				_frameMatrix.ty = -value.y;
				_width = value.width;
				_height = value.height;
			}
		}
		
		public function set region(value:Rectangle):void
		{
			assert(_gpuTexture && !hasFrame);
			const isValueNotNull:Boolean = (value != null);
			if(isValueNotNull){
				_width = value.width;
				_height = value.height;
				var ratioX:Number = 1 / _gpuTexture.width;
				var ratioY:Number = 1 / _gpuTexture.height;
				_regionMatrix.a = ratioX * value.width;
				_regionMatrix.d = ratioY * value.height;
				_regionMatrix.tx = ratioX * value.x;
				_regionMatrix.ty = ratioY * value.y;
			}else if(hasRegion){
				_width = _gpuTexture.width;
				_height = _gpuTexture.height;
				_regionMatrix.identity();
			}
			hasRegion = isValueNotNull;
		}
		
		public function get width():int
		{
			return _width;
		}
		
		public function get height():int
		{
			return _height;
		}
		
		public function get frameMatrix():Matrix
		{
			return _frameMatrix;
		}
		
		public function get uvMatrix():Matrix
		{
			return _regionMatrix;
		}
		
		public function get scale9():Vector.<Number>
		{
			return _scale9;
		}
		
		public function set scale9grid(value:Rectangle):void
		{
			if(null == value){
				_scale9 = null;
				return;
			}
			_scale9 = new Vector.<Number>(4, true);
			_scale9[0] = value.x;
			_scale9[1] = gpuTexture.width - value.right;
			_scale9[2] = value.y;
			_scale9[3] = gpuTexture.height - value.bottom;
		}
		
		public function clone():Texture2D
		{
			var copy:Texture2D = new Texture2D(_gpuTexture);
			copy.hasFrame = hasFrame;
			copy._frameMatrix.copyFrom(_frameMatrix);
			copy.hasRegion = hasRegion;
			copy._regionMatrix.copyFrom(_regionMatrix);
			if(_scale9 != null){
				copy._scale9 = _scale9.slice();
			}
			copy._width = _width;
			copy._height = _height;
			return copy;
		}
		
		public function flipX():void
		{
			_regionMatrix.tx += _regionMatrix.a;
			_regionMatrix.a *= -1;
		}
		
		public function flipY():void
		{
			_regionMatrix.ty += _regionMatrix.d;
			_regionMatrix.d *= -1;
		}
		
		public function flipXY():void
		{
			flipX();
			flipY();
		}
	}
}