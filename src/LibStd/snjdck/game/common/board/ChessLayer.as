package snjdck.game.common.board
{
	import flash.display.DisplayObject;
	
	import stdlib.components.ObjectPool;
	
	
	public class ChessLayer extends Layer
	{
		private const cache:Object = {};
		private const map:Map = new Map();
		private const hashMap:Object = {};
		
		public function ChessLayer(boxWidth:int, boxHeight:int, gapWidth:int, gapHeight:int)
		{
			super(boxWidth, boxHeight, gapWidth, gapHeight);
		}
		
		public function reset():void
		{
			map.reset(__callback);
		}
		
		private function __callback(icon:DisplayObject):void
		{
			cache[hashMap[icon]].setObjectIn(icon);
		//	cache[int(icon.name)].setObjectIn(icon);
		}
		
		public function setValueAt(px:int, py:int, value:int):void
		{
			
			var icon:DisplayObject = map.getValueAt(px, py);
			
			if(null != icon)//如果这里原来有棋子,先回收掉
			{
				cache[hashMap[icon]].setObjectIn(icon);
			//	cache[int(icon.name)].setObjectIn(icon);
				map.setValueAt(px, py, null);
			}
			
			if(0 != value)//设置成选中状态
			{
				icon = this.getChessById(value);
				
				this.moveChildTo(icon, px, py);
				
				map.setValueAt(px, py, icon);
				
				hashMap[icon] = value;		//存下icon所对应的id值
			//	icon.name = value.toString();
			}
		}
		
		private function getChessById(id:int):DisplayObject
		{
			var chess:DisplayObject;
			
			if(null == cache[id])
			{
				var pool:ObjectPool = new ObjectPool(this.getClassById(id));
				/*
				pool.onCreateObject = __onIconCreate;
				pool.onGetObjectOut = __onGetIcon;
				pool.onSetObjectIn = __onReleaseIcon;
				*/
				cache[id] = pool;
			}
			
			chess = cache[id].getObjectOut() as DisplayObject;
			
			return chess;
		}
		
		protected function getClassById(id:int):Class
		{
			return null;
		}
		
		//回调函数
		
		private function __onIconCreate(icon:DisplayObject):void
		{
			this.addChild(icon);
		}
		
		private function __onGetIcon(icon:DisplayObject):void
		{
			icon.visible = true;
		}
		
		private function __onReleaseIcon(icon:DisplayObject):void
		{
			icon.visible = false;
		}
		//over
	}
}