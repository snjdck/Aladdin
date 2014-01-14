package
{
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	import stdlib.filesystem.FileIO;
	
	import string.replace;

	public class CodeGenerator
	{
		[Embed(source="/class_templete", mimeType="application/octet-stream")]
		static private const CODE_TEMPLETE_CLS:Class;
		static private const CODE_TEMPLETE:String = new CODE_TEMPLETE_CLS().toString();
		
		/** 包含包名 */
		public var baseClassName:String;
		public var className:String;
		
		private const children:Array = [];
		
		public function CodeGenerator(className:String, baseClassName:String)
		{
			this.baseClassName = baseClassName;
			this.className = className;
		}
		
		public function addChild(name:String, type:String, x:Number, y:Number, width:Number, height:Number):void
		{
			children.push(arguments);
		}
		
		public function build():String
		{
			var context:Object = {
				"packageName":getPackageName(),
				"class_import":"import " + baseClassName + ";",
				"className":getClassName(),
				"baseClassName":baseClassName,
				"class_properties":createChild(tem2),
				"init_code":createChild(tem1)
			};
			return string.replace(CODE_TEMPLETE, context);
		}
		
		public function save(dirPath:String):void
		{
			var ba:ByteArray = new ByteArray();
			ba.writeUTFBytes(build());
			FileIO.Write(new File(dirPath + "/" + getClassName() + ".as"), ba);
			ba.clear();
		}
		
		static private const tem2:String = "public var ${0}:${1};";
		static private const tem1:String = "${0} = new ${1}();${0}.x = ${2};${0}.y = ${3};${0}.width = ${4};${0}.height = ${5};";
		
		private function createChild(temp:String):String
		{
			var result:String = "";
			for each(var args:Array in children){
				result += string.replace(temp, args);
			}
			return result;
		}
		
		private function getPackageName():String
		{
			var index:int = className.lastIndexOf(".");
			if(-1 != index){
				return className.slice(0, index);
			}
			
			return "";
		}
		
		public function getClassName():String
		{
			var index:int = className.lastIndexOf(".");
			if(-1 != index){
				return className.slice(index+1);
			}
			
			return className;
		}
	}
}