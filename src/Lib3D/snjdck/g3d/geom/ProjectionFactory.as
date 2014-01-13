package snjdck.g3d.geom
{
	import flash.geom.Matrix3D;
	
	/**
	 * Stage3D默认为:左手坐标系,原点在屏幕中心,x向右,y向上,z向里
	 */	
	final public class ProjectionFactory
	{
		/**
		 * 将Stage3D中"原点在中心,x向右y向上为正"的坐标系转为"原点在左上角,x向右y向下为正"
		 */
		static public const COORDINATE_TRANSFORM:Matrix3D = new Matrix3D(new <Number>[
			1.0,  0.0, 0.0, 0.0,
			0.0, -1.0, 0.0, 0.0,
			0.0,  0.0, 1.0, 0.0,
			-1.0, 1.0, 0.0, 1.0
		]);
		
		/**
		 * @param fieldOfViewY 视野范围(弧度)
		 * @param aspectRatio 高宽比(3/4, 9/16)
		 */		
		static public function PerspectiveFieldOfViewLH(fieldOfViewY:Number, aspectRatio:Number, zNear:Number, zFar:Number):Matrix3D
		{
			var yScale:Number = 1.0 / Math.tan(fieldOfViewY*0.5);
			var xScale:Number = yScale * aspectRatio;
			
			return new Matrix3D(new <Number>[
				xScale, 0.0, 0.0, 0.0,
				0.0, yScale, 0.0, 0.0,
				0.0, 0.0, zFar/(zFar-zNear), 1.0,
				0.0, 0.0, (zNear*zFar)/(zNear-zFar), 0.0
			]);
		}
		
		/** 透视投影 */
		static public function PerspectiveLH(width:Number, height:Number, zNear:Number, zFar:Number):Matrix3D
		{
			return new Matrix3D(new <Number>[
				2.0*zNear/width, 0.0, 0.0, 0.0,
				0.0, 2.0*zNear/height, 0.0, 0.0,
				0.0, 0.0, zFar/(zFar-zNear), 1.0,
				0.0, 0.0, (zNear*zFar)/(zNear-zFar), 0.0
			]);
		}
		
		/** 平行投影 */
		static public function OrthoLH(width:Number, height:Number, zNear:Number, zFar:Number):Matrix3D
		{
			return new Matrix3D(new <Number>[
				2.0/width, 0.0, 0.0, 0.0,
				0.0, 2.0/height, 0.0, 0.0,
				0.0, 0.0, 1.0/(zFar-zNear), 0.0,
				0.0, 0.0, zNear/(zNear-zFar), 1.0
			]);
		}
	}
}