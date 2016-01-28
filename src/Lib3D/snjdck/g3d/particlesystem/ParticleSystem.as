package snjdck.g3d.particlesystem
{
	import flash.display3D.Context3DBlendFactor;
	import flash.geom.Vector3D;
	import flash.support.Range;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.core.Object3D;
	import snjdck.gpu.BlendMode;
	import snjdck.gpu.asset.GpuAssetFactory;
	import snjdck.gpu.asset.GpuIndexBuffer;
	import snjdck.gpu.asset.GpuVertexBuffer;
	
	use namespace ns_g3d;

	/**
	 * 混合模式:source:one, dest:destAlpha
	 * (1, 0, 0, 0) * (1, 1, 1, 1) + destColor * destAlpha
	 */	
	public class ParticleSystem extends Object3D
	{
		private var maxParticles:int;
		
		public var life:Range;//生命值
		/*
		private var emitterPos:Vector3D;//发射方向
		private var emitterDir:Vector3D;//发射方向
		//*/
		public var beginSize:Range;//开始大小
		public var endSize:Range;//结束大小
		
		public var beginColor:RangeVec;
		public var endColor:RangeVec;
		/*
		private var beginRot:Range;//开始旋转度
		private var endRot:Range;//结束旋转度
		//*/
		public var pos:RangeVec;//初始速度
		public var speed:RangeVec;//初始速度
		public var acc:RangeVec;//初始加速度
		
		protected const list:Array = [];
		
		private var gpuVertexBuffer:GpuVertexBuffer;
		private var gpuIndexBuffer:GpuIndexBuffer;
		
		private var globalTime:Number = 0;
		
		public function ParticleSystem(count:int)
		{
			mouseEnabled = false;
			this.maxParticles = count;
			blendMode = new BlendMode(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE);
//			blendFactor = BlendFactor.NORMAL;
			setDefaultProps();
		}
		
		private function setDefaultProps():void
		{
			life = Range.Create(2, 2);
			//*
			beginColor = RangeVec.Create(new Vector3D(0.5, 0.5, 0.5, 1), new Vector3D(1, 1, 1));
			endColor = RangeVec.Create(new Vector3D(0.5, 0.5, 0.5, 0), new Vector3D(1, 1, 1));
			
			beginSize = Range.Create(0.01, 0.0003);
			endSize = Range.Create(0.06, 0.002);
			//*/
			pos = RangeVec.Create(new Vector3D(0, -0.9, 0), new Vector3D(1));
			speed = RangeVec.Create(new Vector3D(0, 5, 0), new Vector3D(2.5, 0, 0));
			acc = RangeVec.Create(new Vector3D(0, -9.8, 0), new Vector3D(0, 0, 0));
		}
		
		private function createParticle():Particle
		{
			var p:Particle = new Particle();
			
			p.life = life.getRandowValue();
			//*
			p.beginSize = beginSize.getRandowValue();
			p.endSize = endSize.getRandowValue();
			//*/
			pos.getRandowValue(p.pos);
			speed.getRandowValue(p.speed);
			acc.getRandowValue(p.acc);
			//*
			beginColor.getRandowValue(p.beginColor);
			endColor.getRandowValue(p.endColor);
			//*/
			return p;
		}
		
		public function createParticles():void
		{
			for(var i:int=0; i<maxParticles; i++){
				var p:Particle = createParticle();
				p.startTime = i / maxParticles;
				list[i] = p;
			}
			initVertexBuffer();
			gpuIndexBuffer = GpuAssetFactory.CreateQuadBuffer(maxParticles);
		}
		
		override public function onUpdate(timeElapsed:int):void
		{
			globalTime += timeElapsed * 0.001;
		}
		/*
		override ns_g3d function collectDrawUnit(collector:DrawUnitCollector3D, camera:Camera3D):void
		{
			var drawUnit:DrawUnit3D = collector.getFreeDrawUnit();
			
			drawUnit.blendFactor = blendMode;
			
			drawUnit.setWorldMatrix(worldMatrix);
			drawUnit.setVcM(8, camera.worldMatrix);
			drawUnit.setVc(12, new<Number>[
				globalTime, 1, 0.5, -0.5
			], 1);
			
			drawUnit.indexBuffer = gpuIndexBuffer;
			
			drawUnit.setVa2(gpuVertexBuffer, [4, 4, 4, 3, 4, 4]);
			
			drawUnit.shaderName = "particle";
			drawUnit.textureName = "psTex";
			
			collector.addDrawUnit(drawUnit);
		}
		*/
		private function initVertexBuffer():void
		{
			var vertexBuffer:Vector.<Number> = new Vector.<Number>();
			
			for(var i:int=0; i<maxParticles; i++){
				var p:Particle = list[i];
				p.copyTo(vertexBuffer, i);
			}
			
			gpuVertexBuffer = GpuAssetFactory.CreateGpuVertexBuffer(vertexBuffer, vertexBuffer.length/(maxParticles*4));
		}
	}
}