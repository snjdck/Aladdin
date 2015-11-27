package snjdck.gpu
{
	import flash.display3D.Context3DProfile;
	
	import snjdck.gpu.asset.GpuProgram;
	import snjdck.gpu.render.instance.InstanceRender;

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
				case Context3DProfile.STANDARD_CONSTRAINED:
					GpuProgram.AgalVersion = 2;
					InstanceRender.MAX_VC_COUNT = 250;
					MaxTextureSize = 4096;
					break;
				case Context3DProfile.BASELINE_EXTENDED:
					GpuProgram.AgalVersion = 1;
					MaxTextureSize = 4096;
					InstanceRender.MAX_VC_COUNT = 128;
					break;
				case Context3DProfile.BASELINE:
					GpuProgram.AgalVersion = 1;
					MaxTextureSize = 2048;
					InstanceRender.MAX_VC_COUNT = 128;
					break;
			}
		}
	}
}