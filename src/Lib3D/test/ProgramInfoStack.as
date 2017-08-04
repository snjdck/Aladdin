package test
{
	import snjdck.gpu.asset.IGpuTexture;

	public class ProgramInfoStack implements IProgramConstContext, IProgramTextureContext
	{
		private const textureStack:Vector.<IProgramTextureContext> = new Vector.<IProgramTextureContext>();
		private const constStack:Vector.<IProgramConstContext> = new Vector.<IProgramConstContext>();
		
		public function ProgramInfoStack(){}
		
		public function pushTexture(value:IProgramTextureContext):void
		{
			textureStack.push(value);
		}
		
		public function popTexture():void
		{
			textureStack.pop();
		}
		
		public function pushConst(value:IProgramConstContext):void
		{
			constStack.push(value);
		}
		
		public function popConst():void
		{
			constStack.pop();
		}
		
		public function loadConst(data:Vector.<Number>, name:String, fromRegister:int, toRegister:int):Boolean
		{
			for(var i:int=constStack.length-1; i>=0; --i){
				var context:IProgramConstContext = constStack[i];
				var success:Boolean = context.loadConst(data, name, fromRegister, toRegister);
				if (success) return true;
			}
			return false;
		}
		
		public function loadTexture(name:String):IGpuTexture
		{
			for(var i:int=textureStack.length-1; i>=0; --i){
				var context:IProgramTextureContext = textureStack[i];
				var result:IGpuTexture = context.loadTexture(name);
				if (result) return result;
			}
			return null;
		}
	}
}