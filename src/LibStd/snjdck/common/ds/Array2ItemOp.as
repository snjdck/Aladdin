package snjdck.common.ds
{
	import snjdck.common.geom.Vec2D;

	public class Array2ItemOp
	{
		protected var target:Array2;
		private var _x:int;
		private var _y:int;
		
		public function Array2ItemOp(target:Array2, x:int, y:int)
		{
			this.target = target;
			this._x = x;
			this._y = y;
		}
		
		public function get x():int
		{
			return _x;
		}

		public function get y():int
		{
			return _y;
		}
		
		public function get pos():Vec2D
		{
			return new Vec2D(x, y);
		}
		
		public function get value():*
		{
			return target.getValueAt(x, y);
		}
	}
}