package snjdck.gpu.asset
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.VideoTexture;
	import flash.events.Event;
	import flash.net.NetStream;

	public class GpuVideoTexture extends GpuAsset implements IGpuTexture
	{
		private const uploadParams:Array = [];
		
		public function GpuVideoTexture()
		{
			super("createVideoTexture", null);
		}
		
		public function attachNetStream(netStream:NetStream):void
		{
			uploadParams[0] = netStream;
			uploadImp("attachNetStream", uploadParams);
		}
		
		public function get format():String
		{
			return Context3DTextureFormat.BGRA;
		}
		
		public function get width():int
		{
			return isTextureReady ? videoWidth : 1;
		}
		
		public function get height():int
		{
			return isTextureReady ? videoHeight : 1;
		}
		
		private var isPathChanged:Boolean;
		private var _path:String;
		
		public function set path(url:String):void
		{
			isEventListened = false;
			isPathChanged = true;
			_path = url;
		}
		
		private var isTextureReady:Boolean;
		private var videoWidth:int;
		private var videoHeight:int;
		private var isEventListened:Boolean;
		
		override public function getRawGpuAsset(context3d:Context3D):*
		{
			var texture:VideoTexture = super.getRawGpuAsset(context3d);
			if(isTextureReady){
				return texture;
			}
			if(!isEventListened){
				var ns:NetStream = uploadParams[0];
				texture.addEventListener(Event.TEXTURE_READY, __onTextureReady);
				texture.addEventListener("renderState", __onRenderState);
				if(isPathChanged){
					ns.play(_path);
					isPathChanged = false;
				}
				isEventListened = true;
			}
			return GpuAssetFactory.DefaultGpuTexture.getRawGpuAsset(context3d);
		}
		
		/** this event fire first */
		private function __onRenderState(evt:Event):void
		{
			var texture:VideoTexture = evt.target as VideoTexture;
			texture.removeEventListener(evt.type, __onRenderState);
			videoWidth = texture.videoWidth;
			videoHeight = texture.videoHeight;
		}
		
		/** this event fire senond */
		private function __onTextureReady(evt:Event):void
		{
			var texture:VideoTexture = evt.target as VideoTexture;
			texture.removeEventListener(evt.type, __onTextureReady);
			isTextureReady = true;
		}
	}
}