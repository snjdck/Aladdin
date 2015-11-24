package snjdck.gpu
{
	import flash.display3D.Context3DProfile;
	
	import snjdck.gpu.asset.GpuProgram;

	public class GpuInfo
	{
		static public var MaxTextureSize:int;
		static public var MaxVcCount:int;
		
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
					MaxVcCount = 250;
					break;
				case Context3DProfile.STANDARD:
					GpuProgram.AgalVersion = 2;
					MaxTextureSize = 4096;
					MaxVcCount = 250;
					break;
				case Context3DProfile.STANDARD_CONSTRAINED:
					GpuProgram.AgalVersion = 2;
					MaxTextureSize = 4096;
					MaxVcCount = 250;
					break;
				case Context3DProfile.BASELINE_EXTENDED:
					GpuProgram.AgalVersion = 1;
					MaxTextureSize = 4096;
					MaxVcCount = 128;
					break;
				case Context3DProfile.BASELINE:
					GpuProgram.AgalVersion = 1;
					MaxTextureSize = 2048;
					MaxVcCount = 128;
					break;
			}
		}
	}
}