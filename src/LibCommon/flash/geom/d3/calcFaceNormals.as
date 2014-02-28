package flash.geom.d3
{
	import vec3.crossProd;
	import vec3.readFromArray;
	import vec3.subtract;

	/**
	 * faceNormals = new Vector.<Number>(indexData.length, true);
	 */
	public function calcFaceNormals(vertexData:Vector.<Number>, indexData:Vector.<uint>, faceNormals:Vector.<Number>):void
	{
		const count:int = indexData.length;
		
		var i:int=0, j:int=0;
		
		while(i < count)
		{
			readFromArray(vertexData, 3*indexData[i++], v0);
			readFromArray(vertexData, 3*indexData[i++], v1);
			readFromArray(vertexData, 3*indexData[i++], v2);
			
			subtract(v1, v0, line1);
			subtract(v2, v0, line2);
			crossProd(line1, line2, normal);
			normal.normalize();
			
			faceNormals[j++] = normal.x;
			faceNormals[j++] = normal.y;
			faceNormals[j++] = normal.z;
		}
	}
}

import flash.geom.Vector3D;

const v0:Vector3D = new Vector3D();
const v1:Vector3D = new Vector3D();
const v2:Vector3D = new Vector3D();

const line1:Vector3D = new Vector3D();
const line2:Vector3D = new Vector3D();
const normal:Vector3D = new Vector3D();