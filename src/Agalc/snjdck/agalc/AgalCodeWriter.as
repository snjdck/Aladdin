package snjdck.agalc
{
	import snjdck.agalc.helper.char2val;
	import snjdck.agalc.helper.flags2swizzle;
	import snjdck.agalc.helper.flags2writeMask;
	
	import string.execRegExp;
	
	internal class AgalCodeWriter
	{
		static private const SlotPattern:RegExp = /([a-z]{1,2})(\d{0,3})(?:\.([xyzw]{1,4}))?/;
		
		private var writer:AgalByteWriter;
		
		public function AgalCodeWriter(writer:AgalByteWriter)
		{
			this.writer = writer;
		}
		
		public function writeDestination(text:String):void
		{
			if(!text){
				writer.writeDestinationDummy();
				return;
			}
			
			const obj:Array = execRegExp(SlotPattern, text);
			
			const registerType:int = Register.FetchByName(obj[1]).type;
			const registerIndex:int = obj[2];
			const writeMask:uint = flags2writeMask(obj[3]);
			
			writer.writeDestination(registerType, registerIndex, writeMask);
		}
		
		public function writeSource(text:String):void
		{
			if(!text){
				writer.writeSourceDummy();
				return;
			}
			
			var indirectObj:Array = execRegExp(/\[.+\]/, text);
			
			if(indirectObj){
				indirectObj = execRegExp(/\[(v[at])(\d)\.([xyzw])(\+\d{1,3})?\]/, text);
				
				if(null == indirectObj){
					throw new Error("indirect register error: " + text);
				}
				
				const indexRegisterType:int = Register.FetchByName(indirectObj[1]).type;
				const indexRegisterComponentSelect:uint = char2val(indirectObj[3]);
				const indirectOffset:int = indirectObj[4];
				
				text = text.replace(indirectObj[0], indirectObj[2]);
			}
			
			const obj:Array = execRegExp(SlotPattern, text);
			
			const registerType:int = Register.FetchByName(obj[1]).type;
			const registerIndex:int = obj[2];
			const swizzle:uint = flags2swizzle(obj[3]);
			
			if(indirectObj){
				writer.writeSourceIndirect(
					registerType, registerIndex, swizzle,
					indexRegisterType, indirectOffset, indexRegisterComponentSelect
				);
			}else{
				writer.writeSourceDirect(registerType, registerIndex, swizzle);
			}
		}
		
		public function writeSampler(source:String):void
		{
			const test:Array = execRegExp(/fs(\d)(?:<([^>]+)>)?/, source);
			
			if(null == test){
				throw new Error("sampler format must be fs0-7!");
			}
			
			const registerIndex:int = test[1];
			const flags:String = test[2];
			
			var dimension:uint = 0;		//0=2D, 1=Cube, 2=3D
			var filter:uint = 1;		//0=nearest, 1=linear
			var mipmap:uint = 0;		//0=disable, 1=nearest, 2=linear
			var wrapping:uint = 1;		//0=clamp, 1=repeat
			var textureFormat:uint = 0;	//0=rgba, 1=dxt1, 2=dxt5, 3=video
			var special:uint = 0;
			
			for each(var flag:String in (flags && flags.split(","))){
				switch(flag.toLowerCase()){
					case "3d":
						dimension = 2;
						break;
					case "cube":
						dimension = 1;
						break;
					case "nearest":
						filter = 0;
						break;
					case "mipnearest":
						mipmap = 1;
						break;
					case "miplinear":
						mipmap = 2;
						break;
					case "clamp":
						wrapping = 0;
						break;
					case "repeat":
						wrapping = 1;
						break;
					case "rgba":
						textureFormat = 0;
						break;
					case "dxt1":
						textureFormat = 1;
						break;
					case "dxt5":
						textureFormat = 2;
						break;
					case "centroid":
						special |= 1;
						break;
					case "single":
						special |= 2;
						break;
					case "ignoresampler":
						special |= 4;
						break;
				}
			}
			
			writer.writeSampler(registerIndex, dimension, filter, mipmap, wrapping, textureFormat, special);
		}
	}
}