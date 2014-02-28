package snjdck.tesla.kernel.services
{
	import flash.media.Sound;
	
	public interface IAssetService
	{
		function regAsset(assetName:String, data:Object):void;
		function hasAsset(assetName:String):Boolean;
		function getAsset(assetName:String):Object;
		
		function getSound(assetName:String):Sound;
	}
}