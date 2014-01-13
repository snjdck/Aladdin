package snjdck.agalc
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	internal class AgalByteWriter
	{
		private var rawData:ByteArray;
		
		public function AgalByteWriter()
		{
		}
		
		public function setRawData(value:ByteArray):void
		{
			rawData = value;
			rawData.endian = Endian.LITTLE_ENDIAN;
			rawData.clear();
		}
		
		public function writeHeader(shaderType:int, version:uint):void
		{
			rawData.writeByte(0xa0);				//magic: must be 0xa0
			rawData.writeUnsignedInt(version);
			rawData.writeByte(0xa1);				//shader type ID: must be 0xa1
			rawData.writeByte(shaderType);			//shader type: 0 for a vertex program; 1 for a fragment program
		}
		
		public function writeOP(op:uint):void
		{
			rawData.writeUnsignedInt(op);
		}
		
		public function writeDestination(registerType:int, registerIndex:int, writeMask:uint):void
		{
			rawData.writeShort(registerIndex);
			rawData.writeByte(writeMask);
			rawData.writeByte(registerType);
		}
		
		public function writeDestinationDummy():void
		{
			rawData.writeUnsignedInt(0);
		}
		
		public function writeSourceDirect(registerType:int, registerIndex:int, swizzle:uint):void
		{
			rawData.writeShort(registerIndex);
			rawData.writeByte(0);
			rawData.writeByte(swizzle);
			rawData.writeUnsignedInt(registerType);
		}
		
		public function writeSourceIndirect(registerType:int, registerIndex:int, swizzle:uint, indexRegisterType:int, indirectOffset:int, indexRegisterComponentSelect:uint):void
		{
			rawData.writeShort(registerIndex);
			rawData.writeByte(indirectOffset);
			rawData.writeByte(swizzle);
			rawData.writeByte(registerType);
			rawData.writeByte(indexRegisterType);
			rawData.writeShort(indexRegisterComponentSelect | (1 << 15));
		}
		
		public function writeSourceDummy():void
		{
			rawData.writeUnsignedInt(0);
			rawData.writeUnsignedInt(0);
		}
		
		public function writeSampler(registerIndex:int, dimension:int, filter:int, mipmap:int, wrapping:int, format:int, special:int):void
		{
			rawData.writeShort(registerIndex);
			rawData.writeShort(0);
			rawData.writeByte(RegisterType.Sampler);
			rawData.writeByte(format	| (dimension	<< 4));
			rawData.writeByte(special	| (wrapping		<< 4));
			rawData.writeByte(mipmap	| (filter		<< 4));
		}
	}
}