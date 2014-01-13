package f2d
{
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;

	public function initStage(stage:Stage):void
	{
		stage.align = StageAlign.TOP_LEFT;		//默认值为""(空字符串)
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.quality = StageQuality.HIGH;
		stage.showDefaultContextMenu = false;
		stage.stageFocusRect = false;
	}
}