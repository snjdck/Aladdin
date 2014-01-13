package matrix44
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import vec3.crossProd;
	import vec3.dotProd;

	/** left hand */
	public function lookAtDirection(eye:Vector3D, direction:Vector3D, up:Vector3D, output:Matrix3D):void
	{
		z.copyFrom(direction);
		z.normalize();
		
		crossProd(up, z, x);
		x.normalize();
		
		crossProd(z, x, y);
		
		w.x = dotProd(eye, x);
		w.y = dotProd(eye, y);
		w.z = dotProd(eye, z);
			
		output.copyColumnFrom(0, x);
		output.copyColumnFrom(1, y);
		output.copyColumnFrom(2, z);
		output.copyColumnFrom(3, w);
	}
}

import flash.geom.Vector3D;

const x:Vector3D = new Vector3D(0, 0, 0, 0);
const y:Vector3D = new Vector3D(0, 0, 0, 0);
const z:Vector3D = new Vector3D(0, 0, 0, 0);
const w:Vector3D = new Vector3D(0, 0, 0, 1);