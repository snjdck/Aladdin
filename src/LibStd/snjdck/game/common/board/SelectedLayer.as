package snjdck.game.common.board
{
	
	import flash.display.DisplayObject;
	
	import flash.support.ObjectPool;

	internal class SelectedLayer extends Layer
	{
		private const map:Map = new Map();
		private var Icon:Class;
		private var cache:ObjectPool;
		
		public function SelectedLayer(boxWidth:int, boxHeight:int, gapWidth:int, gapHeight:int)
		{
			super(boxWidth, boxHeight, gapWidth, gapHeight);
		}
		
		public function setIconClass(value:Class):void
		{
			this.Icon = value;
			
			cache = new ObjectPool(Icon);
			/*
			cache.onCreateObject = __onIconCreate;
			cache.onGetObjectOut = __onGetIcon;
			cache.onSetObjectIn = __onReleaseIcon;
			*/
		}
		
		public function reset():void
		{
			map.reset(__callback);
		}
		
		private function __callback(icon:DisplayObject):void
		{
			cache.setObjectIn(icon);
		}
		
		public function setSelectedAt(px:int, py:int, flag:Boolean):void
		{
			var icon:DisplayObject;
			
			if(flag)//设置成选中状态
			{
				if(null == map.getValueAt(px, py))
				{
					icon = cache.getObjectOut() as DisplayObject;
					this.moveChildTo(icon, px, py);
					map.setValueAt(px, py, icon);
				}
			}
			else//取消选中状态
			{
				icon = map.getValueAt(px, py);
				if(null != icon)
				{
					cache.setObjectIn(icon);
					map.setValueAt(px, py, null);
				}
			}
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