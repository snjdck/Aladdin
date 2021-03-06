package snjdck.gpu.asset
{
	import flash.display3D.Context3D;
	import flash.system.IsPlayerVersionHigherThan;
	
	internal class GpuAsset implements IGpuAsset
	{
		static protected const canUseBufferUsage:Boolean = IsPlayerVersionHigherThan(12);
		
		private var prevContext3d:Context3D;
		
		private var rawAsset:*;
		private var isDataDirty:Boolean;
		
		private var initName:String;
		protected var initParams:Array;
		
		private var uploadName:String;
		private var uploadParams:Array;
		
		public function GpuAsset(initName:String, initParams:Array)
		{
			this.initName = initName;
			this.initParams = initParams;
		}
		
		final public function freeGpuMemory():void
		{
			if(rawAsset != null){
				rawAsset.dispose();
				rawAsset = null;
				isDataDirty = true;
			}
		}
		
		public function dispose():void
		{
			prevContext3d = null;
			
			freeGpuMemory();
			
			initName = null;
			initParams = null;
			
			uploadName = null;
			uploadParams = null;
		}
		
		final protected function uploadImp(funcName:String, funcParams:Array):void
		{
			uploadName = funcName;
			uploadParams = funcParams;
			isDataDirty = true;
		}
		
		public function getRawGpuAsset(context3d:Context3D):*
		{
			if(prevContext3d != context3d){
				rawAsset = null;
				isDataDirty = true;
				prevContext3d = context3d;
			}
			if(null == rawAsset){
				rawAsset = context3d[initName].apply(null, initParams);
			}
			if(isDataDirty && uploadName){
				rawAsset[uploadName].apply(null, uploadParams);
				isDataDirty = false;
			}
			return rawAsset;
		}
	}
}