package matrix44
{
	import flash.geom.Matrix3D;
	import flash.geom.Orientation3D;

	public function recompose(
		output:Matrix3D,
		x:Number, y:Number, z:Number,
		rotationX:Number, rotationY:Number, rotationZ:Number,
		scaleX:Number, scaleY:Number, scaleZ:Number
	):void{
		components[0].setTo(x, y, z);
		components[1].setTo(rotationX, rotationY, rotationZ);
		components[2].setTo(scaleX, scaleY, scaleZ);
		
		output.recompose(components, Orientation3D.EULER_ANGLES);
	}
}

import flash.geom.Vector3D;

const components:Vector.<Vector3D> = new <Vector3D>[new Vector3D(), new Vector3D(), new Vector3D()];