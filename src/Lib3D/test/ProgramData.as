package test
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public class ProgramData
	{
		private var programType:String;
		
		public var _input:Array;
		public var _const:Object;
		
		private var firstRegister:int;
		public var numRegisters:int;
		public const data:ByteArray = new ByteArray();
		public const code:ByteArray = new ByteArray();
		
		private var constVector:Vector.<Number>;
		
		public function ProgramData(programType:String)
		{
			this.programType = programType;
			code.endian = Endian.LITTLE_ENDIAN;
		}
		
		internal function calcFirstRegister():void
		{
			for each(var data:Array in _const){
				firstRegister = Math.max(firstRegister, data[1]);
			}
			constVector = new Vector.<Number>(firstRegister << 2, true);
		}

		public function upload(context3d:Context3D, context:IProgramContext):void
		{
			var i:int, n:int = _input.length;
			if(programType == Context3DProgramType.VERTEX){
				for(i=0; i<n; ++i){
					var vertexBuffer:VertexBuffer3DInfo = context.loadVertexBuffer(_input[i][0]);
					context3d.setVertexBufferAt(i, vertexBuffer.buffer.getRawGpuAsset(context3d), vertexBuffer.offset, _input[i][1]);
				}
			}else{
				for(i=0; i<n; ++i){
					context3d.setTextureAt(i, context.loadTexture(_input[i][0]));
				}
			}
			for(var key:String in _const){
				var info:Array = _const[key];
				context.loadConst(constVector, key, info[0], info[1]);
			}
			if(firstRegister > 0){
				context3d.setProgramConstantsFromVector(programType, 0, constVector, firstRegister);
			}
			if(numRegisters > 0){
				context3d.setProgramConstantsFromByteArray(programType, firstRegister, numRegisters, data, 0);
			}
		}
	}
}