package flash.geom.d3
{
	/**
	 * vertexNormals = new Vector.<Number>(vertexData.length, true);
	 */
	public function calcVertexNormals(faceNormals:Vector.<Number>, indexData:Vector.<uint>, vertexNormals:Vector.<Number>):void
	{
		var nx:Number, ny:Number, nz:Number;
		var f0:int, f1:int, f2:int;
		var count:int, index:int;
		
		count = vertexNormals.length;
		while(f0 < count){
			vertexNormals[f0++] = 0;
		}
		
		f0 = 0; f1 = 1; f2 = 2;
		count = faceNormals.length;
		
		while(f0 < count)
		{
			nx = faceNormals[f0];
			ny = faceNormals[f1];
			nz = faceNormals[f2];
			
			index = indexData[f0] * 3;
			vertexNormals[index++] += nx;
			vertexNormals[index++] += ny;
			vertexNormals[index] += nz;
			
			index = indexData[f1] * 3;
			vertexNormals[index++] += nx;
			vertexNormals[index++] += ny;
			vertexNormals[index] += nz;
			
			index = indexData[f2] * 3;
			vertexNormals[index++] += nx;
			vertexNormals[index++] += ny;
			vertexNormals[index] += nz;
			
			f0 += 3;
			f1 += 3;
			f2 += 3;
		}
		
		f0 = 0; f1 = 1; f2 = 2;
		count = vertexNormals.length;
		
		while(f0 < count)
		{
			nx = vertexNormals[f0];
			ny = vertexNormals[f1];
			nz = vertexNormals[f2];
			
			var d:Number = 1 / Math.sqrt(nx*nx + ny*ny + nz*nz);
			
			vertexNormals[f0] = nx * d;
			vertexNormals[f1] = ny * d;
			vertexNormals[f2] = nz * d;
			
			f0 += 3;
			f1 += 3;
			f2 += 3;
		}
	}
}