package snjdck.g3d.terrain
{
	public class EmptyTerrain implements ITerrain
	{
		public function EmptyTerrain()
		{
		}
		
		public function update(timeElapsed:int):void
		{
		}
		
		public function needDraw():Boolean
		{
			return false;
		}
		
		public function draw():void
		{
		}
	}
}