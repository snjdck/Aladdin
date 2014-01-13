package snjdck.game.common.utils
{
	import snjdck.game.common.utils.ds.IntMap;
	
	final public class Checker
	{
		public static const ERR_MAP_IS_NULL:String = "Map不能为空!";
		
		/**
		 * 返回水平方向上两点之间不为0的节点个数(不包括端点)
		 * @param x1 第一个点的x坐标
		 * @param x2 第二个点的x坐标
		 * @param y 两点所在的y位置
		 * @return 两点之间不为0的点的总数
		 * 
		 */	
		public static function getHorNodeSum(map:IntMap, x1:int, x2:int, y:int):int
		{
			if(null == map)
			{
				throw new Error(ERR_MAP_IS_NULL);
			}
			
			if(x1 == x2)
			{
				return 0;
			}
			//
			var i:int;
			var sum:int = 0;
			
			var min:int = x1;
			var max:int = x2;
			//
			if(x1 > x2)
			{
				min = x2;
				max = x1;
			}
			
			for(i=min+1; i<max; i++)
			{
				if( map.getValueAt(i, y) != 0 )
				{
					++sum;
				}
			}
			
			return sum;
		}
		
		/**
		 * 返回竖直方向上两点之间不为0的节点个数(不包括端点)
		 * @param y1 第一个点的y坐标
		 * @param y2 第二个点的y坐标
		 * @param x 两点所在的x位置
		 * @return 两点之间不为0的点的总数
		 * 
		 */	
		public static function getVerNodeSum(map:IntMap, y1:int, y2:int, x:int):int
		{
			if(null == map)
			{
				throw new Error(ERR_MAP_IS_NULL);
			}
			
			if(y1 == y2)
			{
				return 0;
			}
			//
			var i:int;
			var sum:int = 0;
			
			var min:int = y1;
			var max:int = y2;
			//
			if(y1 > y2)
			{
				min = y2;
				max = y1;
			}
			
			for(i=min+1; i<max; i++)
			{
				if( map.getValueAt(x, i) != 0 )
				{
					++sum;
				}
			}
			
			return sum;
		}
		
		/**
		 * 检查国际象棋中象能否从A点走到B点
		 * 象的规则:走斜线,不能越子
		 * @param pa 起点
		 * @param pb 终点
		 * @return 能走过去则返回true,否则返回false
		 * 
		 */	
		public static function check_xiang(map:IntMap, ax:int, ay:int, bx:int, by:int):Boolean
		{
			if(null == map)
			{
				throw new Error(ERR_MAP_IS_NULL);
			}
			
			var dx:int = bx - ax;//两个棋子的水平距离
			var dy:int = by - ay;//两个棋子的垂直距离
			
			var i:int;
			
			if( dx == dy )//--"\"线
			{
				if( dx > 0 )
				{
					for(i=1; i<dx; i++)
					{
						if( map.getValueAt(ax+i, ay+i) != 0 )
						{
							return false;
						}
					}
				}
				else // dx < 0
				{
					for(i=-1; i>dx; i--)
					{
						if( map.getValueAt(ax+i, ay+i) != 0 )
						{
							return false;
						}
					}
				}
				
				return true;
			}
			else if( dx == -dy )//--"/"线
			{
				if( dx > 0 )
				{
					for(i=1; i<dx; i++)
					{
						if( map.getValueAt(ax+i, ay-i) != 0 )
						{
							return false;
						}
					}
				}
				else // dx < 0
				{
					for(i=-1; i>dx; i--)
					{
						if( map.getValueAt(ax+i, ay-i) != 0 )
						{
							return false;
						}
					}
				}
				
				return true;
			}
			else
			{
				return false;
			}
		}
		/*
		//五子棋算法检查
		private function checkWin(px:int, py:int):Boolean
		{
			this.px = px;
			this.py = py;
			//分为四个方向的检查:水平,竖直,左斜线,右斜线
			if( check(fun_hor) ) return true;
			if( check(fun_ver) ) return true;
			if( check(fun_left_bias) ) return true;
			if( check(fun_right_bias) ) return true;
			return false;
		}
		
		private var px:int;
		private var py:int;
		
		//private var i:int;
		//private var j:int;
		private var offset:int;
		//private var sum:int;
		
		private function check(fun:Function):Boolean
		{
			var sum:int = 0;
			var i:int = 0;
			var j:int = 0;
			
			for(i=-4; i<=0; i++)
			{
				sum = 0;
				for(j=0; j<5; j++)
				{
					offset = i+j;
					
					if( fun() )
					{
						if(++sum == 5)
						{
							return true;
						}
					}
					else
					{
						break;
					}
				}
			}
			return false;
		}
		
		private function fun_hor():Boolean
		{
			return this.getValueAt(px+offset, py) == myColor;
		}
		
		private function fun_ver():Boolean
		{
			return this.getValueAt(px, py+offset) == myColor;
		}
		
		private function fun_left_bias():Boolean
		{
			return this.getValueAt(px+offset, py+offset) == myColor;
		}
		
		private function fun_right_bias():Boolean
		{
			return this.getValueAt(px+offset, py-offset) == myColor;
		}
		*/
		//over
	}
}