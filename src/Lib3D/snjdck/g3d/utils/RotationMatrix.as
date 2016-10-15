package snjdck.g3d.utils
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import vec3.crossProd;

	final public class RotationMatrix
	{
		public const transform:Matrix3D = new Matrix3D();
		public const transformInvert:Matrix3D = new Matrix3D();
		
		private const xAxis:Vector3D = new Vector3D();
		private const yAxis:Vector3D = new Vector3D();
		
		public function RotationMatrix(upDir:Vector3D, zAxis:Vector3D)
		{
			vec3.crossProd(upDir, zAxis, xAxis);
			vec3.crossProd(zAxis, xAxis, yAxis);
			xAxis.normalize();
			yAxis.normalize();
			transform.copyRowFrom(0, xAxis);
			transform.copyRowFrom(1, yAxis);
			transform.copyRowFrom(2, zAxis);
			transformInvert.copyFrom(transform);
			transformInvert.invert();
		}
	}
}