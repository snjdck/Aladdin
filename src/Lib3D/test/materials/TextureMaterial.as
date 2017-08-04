package test.materials
{
	import snjdck.gpu.asset.IGpuTexture;

	public class TextureMaterial extends Material
	{
		public function TextureMaterial()
		{
			super();
		}
		
		override public function loadTexture(name:String):IGpuTexture
		{
			return null;
		}
	}
}