package snjdck.g3d.geom
{
	import flash.geom.Matrix3D;
	import flash.lang.ISerializable;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	
	import snjdck.g3d.parser.Geometry;

	public class Bound implements ISerializable
	{
		static public function Create(g:Geometry):Bound
		{
			var bound:Bound = new Bound();
			g.calculateBound(bound);
			return bound;
		}
		
		public var minX:Number;
		public var minY:Number;
		public var minZ:Number;
		public var maxX:Number;
		public var maxY:Number;
		public var maxZ:Number;
		public var radius:Number;
		
		public function Bound()
		{
			minX = minY = minZ = Number.POSITIVE_INFINITY;
			maxX = maxY = maxZ = Number.NEGATIVE_INFINITY;
			radius = 0;
		}
		
		public function transform(matrix:Matrix3D, aabbPoints:Vector.<Number>):void
		{
			aabbPoints[0] = minX;	aabbPoints[1] = minY;	aabbPoints[2] = minZ;
			aabbPoints[3] = maxX;	aabbPoints[4] = minY;	aabbPoints[5] = minZ;
			aabbPoints[6] = minX;	aabbPoints[7] = maxY;	aabbPoints[8] = minZ;
			aabbPoints[9] = maxX;	aabbPoints[10] = maxY;	aabbPoints[11] = minZ;
			aabbPoints[12] = minX;	aabbPoints[13] = minY;	aabbPoints[14] = maxZ;
			aabbPoints[15] = maxX;	aabbPoints[16] = minY;	aabbPoints[17] = maxZ;
			aabbPoints[18] = minX;	aabbPoints[19] = maxY;	aabbPoints[20] = maxZ;
			aabbPoints[21] = maxX;	aabbPoints[22] = maxY;	aabbPoints[23] = maxZ;
			
			matrix.transformVectors(aabbPoints, aabbPoints);
		}
		
		public function toString():String
		{
			return "Bound:" + minX + " " + minY + " " + minZ + " " + maxX + " " + maxY + " " + maxZ + ", radius:" + radius;
		}
		
		public function readFromBuffer(buffer:IDataInput):void
		{
			minX = buffer.readFloat();
			minY = buffer.readFloat();
			minZ = buffer.readFloat();
			maxX = buffer.readFloat();
			maxY = buffer.readFloat();
			maxZ = buffer.readFloat();
			radius = buffer.readFloat();
		}
		
		public function writeToBuffer(buffer:IDataOutput):void
		{
			buffer.writeFloat(minX);
			buffer.writeFloat(minY);
			buffer.writeFloat(minZ);
			buffer.writeFloat(maxX);
			buffer.writeFloat(maxY);
			buffer.writeFloat(maxZ);
			buffer.writeFloat(radius);
		}
	}
}