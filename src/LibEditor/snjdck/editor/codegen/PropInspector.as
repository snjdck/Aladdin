package snjdck.editor.codegen
{
	import flash.display.DisplayObject;
	import flash.display.ImageControl;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.reflection.getTypeName;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class PropInspector extends Sprite
	{
		private var targetTxt:TextField;
		private const itemList:Array = [];
		private var control:ImageControl;
		
		public function PropInspector(control:ImageControl)
		{
			this.control = control;
			
			targetTxt = new TextField();
			targetTxt.defaultTextFormat = new TextFormat("宋体", 12);
			targetTxt.autoSize = TextFieldAutoSize.LEFT;
			targetTxt.mouseEnabled = false;
			addChild(targetTxt);
			
			opaqueBackground = 0xCCCC33;
			control.addEventListener(Event.CHANGE, __onTargetChange);
		}
		
		public function addItem(label:String):void
		{
			var item:PropItemView = new PropItemView(control, label);
			itemList.push(item);
			item.y = itemList.length * 24;
			addChild(item);
		}
//		
//		public function setTarget(control:ImageControl):void
//		{
//			for each(var item:PropItemView in itemList){
//				item.setTarget(control);
//			}
//			control.addEventListener(Event.CHANGE, __onTargetChange);
//		}
		
		public function clearTargetInfo():void
		{
			targetTxt.visible = false;
			for each(var item:PropItemView in itemList){
				item.visible = false;
			}
		}
		
//		private var _target:Object;
		
		private function __onTargetChange(evt:Event):void
		{
			changeTarget(control.getTarget());
		}
		
		private function changeTarget(target:DisplayObject):void
		{
			targetTxt.visible = true;
			var typeName:String = getTypeName(target, true);
			
			if(typeName != targetTxt.text){
				while(itemList.length > 0){
					removeChild(itemList.pop());
				}
				for each(var key:String in PropKeys.Instance.getKeys(typeName)){
					addItem(key);
				}
				targetTxt.text = typeName;
			}
			
			for each(var item:PropItemView in itemList){
				item.visible = true;
				item.active();
			}
		}
		/*
		public function activeTarget(target:Object):void
		{
			targetTxt.text = getTypeName(target, true);
			for each(var item:PropItemView in itemList){
				item.visible = true;
				item.active();
			}
		}
		*/
		/*
		public function updateTarget(target:DisplayObject):void
		{
			for each(var item:PropItemView in itemList){
				item.setTarget(target);
			}
		}
		//*/
	}
}

import flash.debugger.enterDebugger;
import flash.display.DisplayObject;
import flash.display.ImageControl;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.reflection.getTypeName;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.ui.Keyboard;

import snjdck.editor.codegen.ClassDef;
import snjdck.editor.codegen.ItemData;

class PropItemView extends Sprite
{
	private var labelTxt:TextField;
	private var input:TextField;
	
	private var control:ImageControl;
	private var key:String;
	
	public function PropItemView(control:ImageControl, key:String)
	{
		this.control = control;
		this.key = key;
		
		labelTxt = new TextField();
		labelTxt.defaultTextFormat = new TextFormat("宋体", 12);
		labelTxt.autoSize = TextFieldAutoSize.LEFT;
		labelTxt.selectable = false;
		labelTxt.text = key;
		
		input = new TextField();
		input.defaultTextFormat = new TextFormat("宋体", 12);
		input.type = TextFieldType.INPUT;
		input.x = 50;
		input.width = 100;
		input.height = labelTxt.height;
		input.background = true;
		input.border = true;
		
		addChild(labelTxt);
		addChild(input);
		
		active();
		input.addEventListener(KeyboardEvent.KEY_DOWN, __onKeyDown);
		input.addEventListener(FocusEvent.FOCUS_OUT, __onFocusOut);
	}
	
	public function get target():DisplayObject
	{
		return control && control.getTarget();
	}
	
	private function __onKeyDown(evt:KeyboardEvent):void
	{
		if(evt.keyCode == Keyboard.ENTER){
			stage.focus = null;
		}
	}
	
	private function __onFocusOut(evt:Event):void
	{
		if(String(ItemData.getKey(target, key)) == input.text){
			return;
		}
		var clsName:String = getTypeName(target, true);
		var info:Object = ClassDef.infoDict[clsName][key];
		control.setTargetProp(key, getRealValue(info ? info.type : "String", input.text));
	}
	
	private function getRealValue(type:String, value:String):*
	{
		switch(type){
			case "Number":
				return parseFloat(value);
			case "String":
				return value;
			case "Boolean":
				return value == "true";
			default:
				trace(type, value);
				enterDebugger();
		}
	}
	
	public function active():void
	{
		if(target != null){
			input.text = ItemData.getKey(target, key);
			input.mouseEnabled = true;
		}else{
			input.text = "";
			input.mouseEnabled = false;
		}
	}
}