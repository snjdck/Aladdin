package snjdck.g2d.particlesystem
{
	import snjdck.gpu.asset.IGpuTexture;
	import snjdck.gpu.render.instance.IInstanceData;

	internal class ParticleInstanceData implements IInstanceData
	{
		private var particleList:Vector.<Particle>;
		private var texture:IGpuTexture;
		
		public function ParticleInstanceData(particleList:Vector.<Particle>, texture:IGpuTexture)
		{
			this.particleList = particleList;
			this.texture = texture;
		}
		
		public function get numRegisterPerInstance():int
		{
			return 2;
		}
		
		public function get numRegisterReserved():int
		{
			return 4;
		}
		
		public function initConstData(constData:Vector.<Number>):void
		{
			constData[12] = texture.width;
			constData[13] = texture.height;
			constData[14] = 0.5;
			constData[15] = 0;
		}
		
		public function updateConstData(constData:Vector.<Number>, instanceOffset:int, instanceCount:int):void
		{
			var offset:int = 16;
			for(var i:int=0; i<instanceCount; ++i){
				var particle:Particle = particleList[instanceOffset+i];
				constData[offset++] = particle.x;
				constData[offset++] = particle.y;
				constData[offset++] = particle.scale;
				constData[offset++] = particle.rotation;
				constData[offset++] = particle.color.red;
				constData[offset++] = particle.color.green;
				constData[offset++] = particle.color.blue;
				constData[offset++] = particle.color.alpha;
			}
		}
	}
}