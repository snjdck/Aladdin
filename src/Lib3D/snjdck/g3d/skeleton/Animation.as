package snjdck.g3d.skeleton
{
	import math.nearEquals;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.geom.Matrix4x4;
	
	use namespace ns_g3d;

	final public class Animation
	{
		ns_g3d var name:String;
		ns_g3d var length:Number;
		
		/** 每根骨骼的keyframes */
		private var trackList:Array;
		private var numKeyFrames:int;
		
		public function Animation(name:String, length:Number)
		{
			this.name = name;
			this.length = length;
			trackList = [];
		}
		
		public function getKeyFrameCount():int
		{
			return numKeyFrames;
		}
		
		ns_g3d function addTrack(boneId:int, keyFrames:Vector.<KeyFrame>):void
		{
			trackList[boneId] = keyFrames;
			numKeyFrames = Math.max(numKeyFrames, keyFrames.length);
		}
		
		internal function getTransform(boneId:int, time:Number, result:Matrix4x4):void
		{
			var keyFrames:Vector.<KeyFrame> = trackList[boneId];
			
			if(null == keyFrames){
				result.identity();
				return;
			}
			
			for(var i:int=keyFrames.length-1; i>=0; i--){
				if(time >= keyFrames[i].time){
					interpolate(keyFrames, i, time, result);
					return;
				}
			}
		}
		
		static private function interpolate(keyFrames:Vector.<KeyFrame>, index:int, time:Number, result:Matrix4x4):void
		{
			var from:KeyFrame = keyFrames[index];
			var to:KeyFrame = (index+1 < keyFrames.length) ? keyFrames[index+1] : null;
			
			if(null == to || nearEquals(time, from.time)){
				result.copyFrom(from.transform);
			}else if(nearEquals(time, to.time)){
				result.copyFrom(to.transform);
			}else{
				from.interpolate(to, time, result);
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