package flash.asset
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import flash.support.Http;
	import flash.http.loadMedia;

	public class AssetLoader extends EventDispatcher
	{
		private var taskList:Vector.<TaskInfo>;
		private var dataDict:Object;
		private var currentTask:TaskInfo;
		
		public function AssetLoader()
		{
			taskList = new Vector.<TaskInfo>();
			dataDict = {};
		}
		
		public function addTask(path:String, type:String=null, id:String=null):void
		{
			if(null == id){
				id = path;
			}
			
			if(null == type){
				var index:int = path.lastIndexOf(".");
				if(-1 != index){
					type = path.slice(index+1);
				}
			}
			
			taskList.push(new TaskInfo(path, type, id));
		}
		
		public function load():void
		{
			if(currentTask){
				return;
			}
			
			if(taskList.length > 0){
				currentTask = taskList.shift();
				loadCurrentTask();
			}else{
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		private function __onLoad(ok:Boolean, data:*):void
		{
			if(ok){
				dataDict[currentTask.id] = parseAsset(currentTask.type, data);
			}
			
			currentTask = null;
			load();
		}
		
		private function parseAsset(assetType:String, assetData:*):Object
		{
			switch(assetType){
				case "txt":
					return assetData.toString();
				case "xml":
					return XML(assetData.toString());
				case "json":
					return JSON.parse(assetData.toString());
				default:
					return assetData;
			}
		}
		
		private function loadCurrentTask():void
		{
			switch(currentTask.type)
			{
				case "swf":
				case "jpg":
				case "png":
				case "gif":
					loadMedia(currentTask.path, __onLoad);
					break;
				default:
					Http.Get(currentTask.path, null, __onLoad);
			}
		}
		
		public function getData(key:String):*
		{
			return dataDict[key];
		}
		
		public function setData(key:String, data:Object):void
		{
			dataDict[key] = data;
		}
		
		public function deleteData(key:String):void
		{
			delete dataDict[key];
		}
	}
}

class TaskInfo
{
	public var path:String;
	public var type:String;
	public var id:String;
	
	public function TaskInfo(path:String, type:String, id:String)
	{
		this.path = path;
		this.type = type;
		this.id = id;
	}
}