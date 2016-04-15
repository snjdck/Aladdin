package snjdck.g3d.terrain
{
	public interface ITerrain
	{
		function update(timeElapsed:int):void;
		function needDraw():Boolean;
		function draw():void;
	}
}