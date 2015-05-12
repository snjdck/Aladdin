package flash.ds
{
	import flash.geom.Point;
	
	import array.append;
	import array.delAt;
	import array.insert;
	import array.insertArray;
	import array.prepend;

	public class Array2
	{
		private var dock:Array;
		private var width:int;
		private var height:int;
		
		public function Array2(width:int, height:int=1, rawData:Array=null)
		{
			this.width = Math.max(1, width);
			this.height = Math.max(1, height);
			
			dock = rawData || [];
			dock.length = getSize();
		}
		
		public function getRawData():Array
		{
			return dock;
		}
		
		public function getWidth():int
		{
			return width;
		}
		
		public function getHeight():int
		{
			return height;
		}
		
		public function getSize():int
		{
			return width * height;
		}
		
		public function setData(val:Array):void
		{
			var n:int = Math.min(getSize(), val.length);
			for(var i:int=0; i<n; i++){
				dock[i] = val[i];
			}
		}
		
		public function clone():Array2
		{
			return new Array2(width, height, dock.slice());
		}
		
		public function fill(obj:Object):void
		{
			for(var i:int=0, n:int=getSize(); i<n; i++){
				dock[i] = obj;
			}
		}
		
		private function getIndex(x:int, y:int):int
		{
			return x + y * width;
		}
		
		public function getValueAt(x:int, y:int=0):*
		{
			if(isIndexInRange(x, y)){
				return dock[getIndex(x, y)];
			}
			return null;
		}
		
		public function setValueAt(x:int, y:int, val:Object):void
		{
			var index:int = getIndex(x, y);
			if(index < getSize()){
				dock[index] = val;
			}
		}
		
		public function swapValueAt(x1:int, y1:int, x2:int, y2:int):void
		{
			if(x1 == x2 && y1 == y2){
				return;
			}
			
			var t:Object = getValueAt(x1, y1);
			setValueAt(x1, y1, getValueAt(x2, y2));
			setValueAt(x2, y2, t);
		}
		
		public function getValue(pos:Object):*
		{
			return getValueAt(pos.x, pos.y);
		}
		
		public function setValue(pos:Object, val:Object):void
		{
			setValueAt(pos.x, pos.y, val);
		}
		
		public function swapValue(pos1:Object, pos2:Object):void
		{
			swapValueAt(pos1.x, pos1.y, pos2.x, pos2.y);
		}
		
		public function isIndexInRange(x:int, y:int):Boolean
		{
			return x < width && y < height && x >= 0 && y >=0;
		}
		
		public function isRectInRange(x:int, y:int, w:int, h:int):Boolean
		{
			return x >= 0 && y >= 0 && (x + w) <= width && (y + h) <= height;
		}
		
		public function getCol(x:int):Array2
		{
			var col:Array = [];
			for(var y:int=0; y<height; y++){
				col[y] = getValueAt(x, y);
			}
			return new Array2(1, height, col);
		}
		
		public function setCol(x:int, col:Array):void
		{
			for(var y:int=0; y<height; y++){
				setValueAt(x, y, col[y]);
			}
		}
		
		public function delCol(x:int):Array2
		{
			if(!isIndexInRange(x, 0)){
				return null;
			}
			
			var col:Array = [];
			for(var y:int=height-1; y>=0; y--){
				col[y] = delAt(dock, getIndex(x, y));
			}
			
			--width;
			
			return new Array2(1, height, col);
		}
		
		public function insertCol(x:int, col:Array):void
		{
			if(x > width){
				x = width;
			}else if(x < 0){
				x = 0;
			}
			
			for(var y:int=height-1; y>=0; y--){
				insert(dock, getIndex(x, y), col[y]);
			}
			
			++width;
		}
		
		public function getRow(y:int):Array2
		{
			var offset:int = y * width;
			return new Array2(width, 1, dock.slice(offset, offset + width));
		}
		
		public function setRow(y:int, row:Array):void
		{
			for(var x:int=0; x<width; x++){
				setValueAt(x, y, row[x]);
			}
		}
		
		public function delRow(y:int):Array2
		{
			if(!isIndexInRange(0, y)){
				return null;
			}
			
			--height;
			
			return new Array2(width, 1, dock.splice(y*width, width));
		}
		
		static private function GetShiftValue(a:int, b:int):int
		{
			var c:int = a % b;
			return c < 0 ? c + b : c;
		}
		
		public function insertRow(y:int, row:Array):void
		{
			if(y > height){
				y = height;
			}else if(y < 0){
				y = 0;
			}
			
			insertArray(dock, y*width, row.slice(0, width));
			
			++height;
		}
		
		/**
		 * 把每行删掉的第一个数据添加到每行的行尾
		 * @param n 向左移动的行数
		 */		
		public function shiftLeft(n:int=1):void
		{
			n = GetShiftValue(n, width);
			
			if(0 == n){
				return;
			}
			
			for(var y:int=0; y<height; y++){
				insertArray(dock,
					(y+1)*width-n,
					dock.splice(y*width, n)
				);
			}
		}
		
		/**
		 * 把每行删掉的最后一个数据添加到每行的行首
		 * @param n 向右移动的行数
		 */		
		public function shiftRight(n:int=1):void
		{
			n = GetShiftValue(n, width);
			
			if(0 == n){
				return;
			}
			
			for(var y:int=0; y<height; y++){
				insertArray(dock,
					y*width,
					dock.splice((y+1)*width-n, n)
				);
			}
		}
		
		/**
		 * 将删掉的最上一行数据添加到最后一行
		 * @param n 向上移动的行数
		 */		
		public function shiftUp(n:int=1):void
		{
			n = GetShiftValue(n, height);
			if(n > 0){
				append(dock, dock.splice(0, width*n));
			}
		}
		
		/**
		 * 将删掉的最后一行数据插入到第一行
		 * @param n 向下移动的行数
		 */		
		public function shiftDown(n:int=1):void
		{
			n = GetShiftValue(n, height);
			if(n > 0){
				prepend(dock, dock.splice(-width*n));
			}
		}
		
		public function appendCol(col:Array):void
		{
			for(var y:int=0; y<height; y++){
				insert(dock,
					(y + 1) * (width + 1) - 1,
					col[y]
				);
			}
			++width;
		}
		
		public function prependCol(col:Array):void
		{	
			for(var y:int=0; y<height; y++){
				insert(dock,
					y * (width + 1),
					col[y]
				);
			}
			++width;
		}
		
		public function appendRow(row:Array):void
		{
			++height;
			append(dock, row.slice(0, width));
		}
		
		public function prependRow(row:Array):void
		{
			++height;
			prepend(dock, row.slice(0, width));
		}
		
		private function swapWH():void
		{
			var t:int = width;
			width = height;
			height = t;
		}
		
		public function rotateLeft():void
		{
			var copy:Array2 = clone();
			swapWH();
			for(var y:int=0; y<height; y++){
				for(var x:int=0; x<width; x++){
					setValueAt(x, y, copy.getValueAt(height-1-y, x));
				}
			}
		}
		
		public function rotateRight():void
		{
			var copy:Array2 = clone();
			swapWH();
			for(var y:int=0; y<height; y++){
				for(var x:int=0; x<width; x++){
					setValueAt(x, y, copy.getValueAt(y, width-1-x));
				}
			}
		}
		
		public function rotate180():void
		{
			dock.reverse();
		}
		
		public function swapCol(x1:int, x2:int):void
		{
			if(x1 == x2){
				return;
			}
			for(var y:int=0; y<height; y++){
				swapValueAt(x1, y, x2, y);
			}
		}
		
		public function swapRow(y1:int, y2:int):void
		{
			if(y1 == y2){
				return;
			}
			for(var x:int=0; x<width; x++){
				swapValueAt(x, y1, x, y2);
			}
		}
		
		public function flipHorizontal():void
		{
			var halfWidth:int = width >> 1;
			for(var x:int=0; x<halfWidth; x++){
				swapCol(x, width-1-x);
			}
		}
		
		public function flipVertical():void
		{
			var halfHeight:int = height >> 1;
			for(var y:int=0; y<halfHeight; y++){
				swapRow(y, height-1-y);
			}
		}
		
		/**
		 * 以左上和右下点连线为对角线进行翻转
		 */		
		public function flipDiagonal():void
		{
			var copy:Array2 = clone();
			swapWH();
			for(var y:int=0; y<height; y++){
				for(var x:int=0; x<width; x++){
					setValueAt(x, y, copy.getValueAt(y, x));
				}
			}
		}
		
		/**
		 * 
		 * @param target
		 * @param offsetX
		 * @param offsetY
		 * @param predicate predicate(newVal, oldVal) -> bool
		 * 
		 */		
		public function mergeInto(target:Array2, offsetX:int, offsetY:int, predicate:Function):void
		{
			var needPredicate:Boolean = (predicate != null);
			var pos:Point = new Point();
			
			for(var y:int=0; y<height; y++)
			{
				for(var x:int=0; x<width; x++)
				{
					pos.x = x;
					pos.y = y;
					
					var newVal:Object = getValue(pos);
					
					pos.offset(offsetX, offsetY);
					var oldVal:Object = target.getValue(pos);
					
					if(needPredicate ? predicate(newVal, oldVal) : true){
						target.setValue(pos, newVal);
					}
				}
			}
		}
		
		/**
		 * @param handle func(col:int, row:int, val:*):void
		 */
		public function forEach(handle:Function):void
		{
			for(var y:int=0; y<height; y++){
				for(var x:int=0; x<width; x++){
					handle(x, y, getValueAt(x, y));
				}
			}
		}
		
		public function equalString(str:String):Boolean
		{
			return dock.toString() == str;
		}
		
		public function toString():String
		{
			var str:String = "";
			
			for(var y:int=0; y<height; y++){
				for(var x:int=0; x<width; x++){
					str += getValueAt(x, y).toString() + ",";
				}
				str += "\n";
			}
			
			return str;
		}
	}
}