package snjdck.game.common.board
{
	internal class Map
	{
		private const map:Object = {};
		
		public function Map()
		{
		}
		
		public function reset(callback:Function=null):void
		{
			var x:String;
			var y:String;
			
			for(y in map)
			{
				if(null != map[y])
				{
					for(x in map[y])
					{
						if(null != map[y][x])
						{
							if(null != callback) callback(map[y][x]);
							map[y][x] = null;
						}
					}
				}
			}
		}
		
		public function getValueAt(x:int, y:int):*
		{
			return null == map[y] ? null : map[y][x];
		}
		
		public function setValueAt(x:int, y:int, value:*):void
		{
			if(null == map[y]) map[y] = {};
			map[y][x] = value;
		}
	}
}