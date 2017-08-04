package test.materials
{
	import snjdck.gpu.support.GpuConstData;
	
	import test.ProgramReader;

	public class ColorMaterial extends Material
	{
		public function ColorMaterial(shader:ProgramReader=null)
		{
			super(shader);
		}
		
		override public function loadConst(data:Vector.<Number>, name:String, fromRegister:int, toRegister:int):Boolean
		{
			if(name == "Color"){
				GpuConstData.SetNumber(data, fromRegister, 1, 0, 0, 1);
				return true;
			}
			return false;
		}
	}
}