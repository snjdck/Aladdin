package snjdck.gpu
{
	import flash.display3D.Context3DProfile;
	
	import snjdck.gpu.asset.GpuProgram;

	public class GpuInfo
	{
		static public var MaxTextureSize:int;
		
		static public function Init(profile:String, driverInfo:String):void
		{
			if(driverInfo.indexOf("Software") >= 0){
				profile = Context3DProfile.BASELINE;
			}
			switch(profile)
			{
				case Context3DProfile.STANDARD_EXTENDED:
					GpuProgram.AgalVersion = 3;
					MaxTextureSize = 4096;
					break;
				case Context3DProfile.BASELINE_EXTENDED:
					GpuProgram.AgalVersion = 1;
					MaxTextureSize = 4096;
					break;
				case Context3DProfile.BASELINE:
					GpuProgram.AgalVersion = 1;
					MaxTextureSize = 2048;
					break;
			}
		}
	}
}