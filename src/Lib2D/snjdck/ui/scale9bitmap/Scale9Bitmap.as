package snjdck.ui.scale9bitmap
{
	import snjdck.ui.Component;
	
	internal class Scale9Bitmap extends Component
	{
		private var info:Scale9BitmapInfo;
		private var _vertices:Vector.<Number>;
		
		public function Scale9Bitmap(info:Scale9BitmapInfo)
		{
			this.info = info;
			
			_vertices = info.createVertices();
			_width = info.width;
			_height = info.height;
			
			draw();
		}
		
		override public function set width(value:Number):void
		{
			_width = value;
			info.updateVerticesX(_vertices, _width);
			draw();
		}
		
		override public function set height(value:Number):void
		{
			_height = value;
			info.updateVerticesY(_vertices, _height);
			draw();
		}
		
		private function draw():void
		{
			graphics.clear();
			info.draw(graphics, _vertices);
		}
	}
}