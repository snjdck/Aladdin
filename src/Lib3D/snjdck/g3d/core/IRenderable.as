package snjdck.g3d.core
{
	import snjdck.g3d.pickup.Ray;
	import snjdck.g3d.render.DrawUnitCollector3D;

	public interface IRenderable
	{
		function onUpdate(timeElapsed:int):void;
		function collectDrawUnit(collector:DrawUnitCollector3D):void;
		function hitTest(localRay:Ray):Boolean;
	}
}