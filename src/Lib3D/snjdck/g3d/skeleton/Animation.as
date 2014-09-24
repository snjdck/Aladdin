package snjdck.g3d.skeleton
{
	import flash.geom.Vector3D;
	
	import math.nearEquals;
	
	import snjdck.g3d.ns_g3d;
	
	use namespace ns_g3d;

	final public class Animation
	{
		ns_g3d var name:String;
		ns_g3d var length:Number;
		
		/** 每根骨骼的keyframes */
		private var trackList:Array;
		
		public function Animation(name:String, length:Number)
		{
			this.name = name;
			this.length = length;
			trackList = [];
		}
		
		ns_g3d function addTrack(boneId:int, keyFrames:Vector.<KeyFrame>):void
		{
			trackList[boneId] = keyFrames;
		}
		
		internal function getTransform(boneId:int, time:Number, result:Transform):void
		{
			var keyFrames:Vector.<KeyFrame> = trackList[boneId];
			
			if(null == keyFrames){
				result.reset();
				return;
			}
			
			for(var i:int=keyFrames.length-1; i>=0; i--){
				if(time >= keyFrames[i].time){
					interpolate(keyFrames, i, time, result);
					return;
				}
			}
		}
		
		static private function interpolate(keyFrames:Vector.<KeyFrame>, index:int, time:Number, result:Transform):void
		{
			var from:KeyFrame = keyFrames[index];
			var to:KeyFrame = (index+1 < keyFrames.length) ? keyFrames[index+1] : null;
			
			if(null == to || nearEquals(time, from.time)){
				result.copyFrom(from.transform);
			}else if(nearEquals(time, to.time)){
				result.copyFrom(to.transform);
			}else{
				Transform.Interpolate(from.transform, to.transform, (time-from.time) / (to.time-from.time), result);
			}
		}
		
		/*
		ns_g3d var offset:Vector.<Vector3D>;
		private function getOffsetData(index:int):Vector3D
		{
			return offset[index < offset.length ? index : 0];
		}
		*/
	}
}