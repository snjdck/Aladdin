package flash.geom.d3
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	/** 等角投影矩阵 */
	public function createIsoMatrix(result:Matrix3D=null):Matrix3D
	{
		if(null == result){
			result = new Matrix3D();
		}else{
			result.identity();
		}
		
		result.appendScale(Math.SQRT2, Math.SQRT2, Math.SQRT2);
		result.appendRotation(45, Vector3D.Z_AXIS);//绕z轴顺时针旋转45度
		result.appendRotation(-120, Vector3D.X_AXIS);//绕x轴逆时针旋转120度
		
		return result;
	}
}