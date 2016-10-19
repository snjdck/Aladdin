package snjdck.g3d.cameras
{
	import snjdck.g3d.bounds.IBound;
	import snjdck.g3d.lights.ILight3D;
	import snjdck.g3d.render.IDrawUnit3D;

	public interface IDrawUnitCollector3D
	{
		function getViewFrustum():IViewFrustum;
		function isInSight(bound:IBound):Boolean;
		
		function addDrawUnit(drawUnit:IDrawUnit3D, priority:int):void;
		function addLight(light:ILight3D):void;
	}
}