package snjdck.fileformat.swf
{
	import flash.utils.ByteArray;
	
	import array.has;
	import array.pushIfNotHas;
	import lambda.callTimes;
	import stdlib.random.random_generateVariableName;

	internal class AbcFile
	{
		private const strList:Array = ["*"];
		private const nsList:Array = [null];
		private const multiNameList:Array = [null];
		private const shaokai:Array = [null];
		
		private const strIndexWhiteList:Array = [];//需要混淆的str index
		private const strIndexBlackList:Array = [];//不能混淆的str index
		
		private var source:ByteArray;
		
		public function AbcFile(bin:ByteArray)
		{
			source = bin;
			init();
		}
		
		private function init():void
		{
			source.position += 4;//version
			
			skip(readInt, 1);//int
			skip(readInt, 1);//uint
			skip(function():void{
				source.position += 8;
			}, 1);//double
			skip(readString, 1);//string
			skip(function():void{
				nsList.push([source.readUnsignedByte(), readInt()]);
			}, 1);//namespace
			skip(function():void{
				skip(readInt);
			}, 1);//ns_set
			skip(readMultiName, 1);//mulity name
			skip(readMethodInfo);
			skip(readMetadataInfo);
			const clsCount:uint = readInt();
			callTimes(clsCount, readInstanceInfo);
			callTimes(clsCount, readClassInfo);
			skip(readScriptInfo);
			skip(readMethodBodyInfo);
			
			if(source.bytesAvailable > 0){
				throw new Error("AbcFile not read to end");
			}else{
				trace("mix success!");
			}
			/*
			ArrayUtil.Append(aaa, strList);
			++a;
			
			if(a == 393){
				aaa = ArrayUtil.Unique(aaa);
				trace(aaa.length);
				var ba:ByteArray = new ByteArray();
				for each(var str:String in aaa){
					ba.writeUTF(str);
				}
				ba.compress(CompressionAlgorithm.LZMA);
				DeCom.file.save(ba);
			}
			//*/
		}
		/*
		static public var a:int;
		static public var aaa:Array = [];
		//*/
		private function readString():void
		{
			var numChar:uint = readInt();
			shaokai.push([source.position, numChar]);
			strList.push(source.readUTFBytes(numChar));
		}
		
		private function readMultiName():void
		{
			var multiName:Array;
			switch(source.readUnsignedByte()){
				case 0x07: case 0x0D://ns + name
					multiName = [readInt(), readInt()];
					break;
				case 0x11: case 0x12:
					break;
				case 0x09: case 0x0E://name + ns_set
					readInt();
					readInt();
					break;
				case 0x0F: case 0x10:
					readInt();//name
					break;
				case 0x1B: case 0x1C:
					readInt();//ns_set
					break;
				case 0x1D:
					readInt();
					skip(readInt);
					break;
				default:
					throw new Error("unknow kind!");
			}
			multiNameList.push(multiName);
		}
		
		private function readMethodInfo():void
		{
			const param_count:uint = readInt();
			readInt();//return type
			callTimes(param_count, readInt);//paramType
			readInt();//name
			const flags:uint = source.readUnsignedByte();
			if(flags & 0x08){//参数默认值
				skip(function():void{
					readInt();//值在常量池中的索引
					source.readUnsignedByte();//值类型
				});
			}
			if(flags & 0x80){//参数名称
				callTimes(param_count, readInt);
			}
		}
		
		private function readMetadataInfo():void
		{
			readInt();//tagName
			skip(function():void{
				readInt();//key
				addNotParsedStrIndex(readInt(), ".");//value
			});
		}
		
		private function readInstanceInfo():void
		{
			readInt();//multiNameIndex
			readInt();//super name
			if(source.readUnsignedByte() & 0x08){
				addNotParsedStrIndex(nsList[readInt()][1], ":");//protected namespace
			}
			skip(readInt);//接口
			//This is an index into the method array of the abcFile;
			//it references the method that is invoked whenever an object of this class is constructed.
			//This method is sometimes referred to as an instance initializer.
			readInt();
			skip(readTraitInfo);
		}
		
		private function readClassInfo():void
		{
			//This is an index into the method array of the abcFile;
			//it references the method that is invoked when the class is first created.
			//This method is also known as the static initializer for the class.
			readInt();
			skip(readTraitInfo);
		}
		
		private function readScriptInfo():void
		{
			//The init field is an index into the method array of the abcFile.
			//It identifies a function that is to be invoked prior to any other code in this script.
			readInt();
			skip(readTraitInfo);
		}
		
		private function readMethodBodyInfo():void
		{
			//The method field is an index into the method array of the abcFile;
			//it identifies the method signature with which this body is to be associated.
			readInt();
			callTimes(4, readInt);
			readInstructionInfo(readInt() + source.position);
			skip(readExceptionInfo);
			skip(readTraitInfo);
		}
		
		private function readExceptionInfo():void{
			callTimes(5, readInt);
		}
		
		private function readTraitInfo():void
		{
			const multiNameIndex:uint = readInt();
			const kind:uint = source.readUnsignedByte();
			switch(kind & 0xF){
				case 0: case 6://slot, const
					readInt();//slot_id
					readInt();//属性类型
					if(readInt() != 0){
						source.readUnsignedByte();
					}
					addPropName(multiNameIndex);
					break;
				case 1: case 5: case 2: case 3://method, function, getter, setter
					addPropName(multiNameIndex);
					readInt();
					readInt();//method array
					break;
				case 4://class
					addClassName(multiNameIndex);
					readInt();
					readInt();//class array
					break;
				default:
					throw new Error("kind error!");
			}
			
			if(kind & 0x40){
				skip(readInt);
			}
		}
		
		private function skip(handler:Function, flag:int=0):void
		{
			var count:uint = readInt();
			while(count-- > flag){
				handler();
			}
		}
		
		private function readInt():uint
		{
			var result:uint = 0;
			var count:int = 0;
			do{
				var byte:uint = source.readUnsignedByte();
				result |= (byte & 0x7F) << (count * 7);
				++count;
			}while((byte & 0x80) != 0 && count < 5);
			return result;
		}
		
		public function mixCode(symbolNames:Array):void
		{
			for each(var strIndex:uint in strIndexWhiteList){
				if(!has(symbolNames, strList[strIndex])){
					mixStr(symbolNames, strIndex);
				}
			}
		}
		
		private function mixStr(symbolNames:Array, strIndex:uint):void
		{
			if(pushIfNotHas(strIndexBlackList, strIndex))
			{
				source.position = shaokai[strIndex][0];
				var nChar:int = shaokai[strIndex][1];
				source.writeUTFBytes(random_generateVariableName(nChar, strList, true));
			}
		}
		
		private function addClassName(nameIndex:int):void
		{
			var info:Array = multiNameList[nameIndex];
			var ns:Array = nsList[info[0]];
			
			switch(ns[0]){
				case 0x05://包外类
					addStrIndexToWhiteList(info[1]);
					break;
				case 0x16://public class
				case 0x17://internal class
					addStrIndexToWhiteList(ns[1]);
					addStrIndexToWhiteList(info[1]);
					break;
			}
		}
		
		private function addPropName(nameIndex:int):void
		{
			var info:Array = multiNameList[nameIndex];
			var ns:Array = nsList[info[0]];
			
			addStrIndexToWhiteList(ns[1]);
//			addStrIndexToWhiteList(info[1]);
			/*
			switch(ns[0]){
				case 0x16://public
				case 0x08://接口,native类方法
				case 0x17://internal
				case 0x18://protected
				case 0x1A://static protected
				case 0x05://private
			}
			//*/
		}
		
		private function addStrIndexToWhiteList(strIndex:uint):void
		{
			pushIfNotHas(strIndexWhiteList, strIndex);
		}
		
		private function addStrIndexToBlackList(strIndex:uint):void
		{
			pushIfNotHas(strIndexBlackList, strIndex);
		}
		
		private function addStrToBlackList(str:String):void
		{
			var strIndex:int = strList.indexOf(str);
			if(strIndex != -1){
				addStrIndexToBlackList(strIndex);
			}
		}
		
		private function addNotParsedStrIndex(strIndex:uint, flag:String):void
		{
			var str:String = strList[strIndex];
			var index:int = str.lastIndexOf(flag);
			if(index != -1){
				addStrToBlackList(str.slice(0, index));
				addStrToBlackList(str.slice(index+1));
			}
			addStrIndexToBlackList(strIndex);
		}
		
		private function readInstructionInfo(endPos:int):void
		{
			const opcode:int = source.readUnsignedByte();
			switch(opcode){
				case 0x2c://pushstring
					addStrIndexToBlackList(readInt());
					break;
				case 0x00:case 0x01:case 0x02://nop
				case 0x03://throw
				case 0x07://dxnslate
				case 0x09://label
				case 0x0a:case 0x0b:
				case 0x1c://pushwith
				case 0x1d://popscope
				case 0x1e://nextname
				case 0x1f://hasnext
				case 0x20://pushnull
				case 0x21://pushundefined
				case 0x23://nextvalue
				case 0x26://pushtrue
				case 0x27://pushfalse
				case 0x28://pushnan
				case 0x29://pop
				case 0x2a://dup
				case 0x2b://swap
				case 0x30://pushscope
				case 0x35://if64
				case 0x36://li16
				case 0x37://li32
				case 0x38://if32
				case 0x3a://si8
				case 0x3b://si16
				case 0x3c://si32
				case 0x3d://sf32
				case 0x47://returnvoid
				case 0x48://returnvalue
				case 0x50://sxi_1
				case 0x51://sxi_8
				case 0x52://sxi_16
				case 0x57://newactivation
				case 0x5a://newcatch
				case 0x64://getglobalscope
				case 0x6a://deleteproperty
				case 0x70://convert_s
				case 0x71://esc_xelem
				case 0x72://esc_xattr
				case 0x73://convert_i
				case 0x74://convert_u
				case 0x75://convert_d
				case 0x76://convert_b
				case 0x77://convert_o
				case 0x78://checkfilter
				case 0x82://coerce_a
				case 0x83://coerce_i
				case 0x84://coerce_d
				case 0x85://coerce_s
				case 0x87://astypelate
				case 0x90://negate
				case 0x91://increment
				case 0x93://decrement
				case 0x95://typeof
				case 0x96://not
				case 0x97://bitnot
				case 0xa0://add
				case 0xa1://subtract
				case 0xa2://multiply
				case 0xa3://divide
				case 0xa4://modulo
				case 0xa5://lshift
				case 0xa6://rshift
				case 0xa7://urshift
				case 0xa8://bitand
				case 0xa9://bitor
				case 0xaa://bitxor
				case 0xab://equals
				case 0xac://strictequals
				case 0xad://lessthan
				case 0xae://lessequals
				case 0xaf://greaterequals
				case 0xb0://greaterthan
				case 0xb1://instanceof
				case 0xb3://istypelate
				case 0xb4://in
				case 0xc0://increment_i
				case 0xc1://decrement_i
				case 0xc4://negate_i
				case 0xc5://add_i
				case 0xc7://multiply_i
				case 0xc6://subtract_i
				case 0xd0://getlocal_0
				case 0xd1://getlocal_1
				case 0xd2://getlocal_2
				case 0xd3://getlocal_3
				case 0xd4://set local 0
				case 0xd5://set local 1
				case 0xd6://set local 2
				case 0xd7://set local 3
					break;
				case 0x04://getsuper
				case 0x05://setsuper
				case 0x06://dxns
				case 0x08://kill
				case 0x25://pushshort
				case 0x2d://pushint
				case 0x2e://pushuint
				case 0x2f://pushdouble
				case 0x31://pushnamespace
				case 0x40://newfunction
				case 0x41://call
				case 0x42://construct
				case 0x49://constructsuper
				case 0x53://applytype
				case 0x55://newobject
				case 0x56://newarray
				case 0x58://newclass
				case 0x59://getdescendants
				case 0x5d://findpropstrict
				case 0x5e://findproperty
				case 0x5f:
				case 0x60://getlex
				case 0x61://setproperty
				case 0x62://getlocal
				case 0x63://setlocal
				case 0x65://getscopeobject
				case 0x66://getproperty
				case 0x68://initproperty
				case 0x6c://getslot
				case 0x6e://getglobalslot
				case 0x6d://setslot
				case 0x6f://setglobalslot
				case 0x80://coerce
				case 0x86://astype
				case 0x92://inclocal
				case 0x94://declocal
				case 0xb2://istype
				case 0xc2://inclocal_i
				case 0xc3://declocal_i
				case 0xf0://debugline
				case 0xf1://debugfile
				case 0xf2:
					readInt();
					break;
				case 0x43://callmethod
				case 0x44://callstatic
				case 0x45://callsuper
				case 0x46://callproperty
				case 0x4a://constructprop
				case 0x4c://callproplex
				case 0x4e://callsupervoid
				case 0x4f://callpropvoid
					readInt();
					readInt();
					break;
				case 0xef://debug
					source.readUnsignedByte();
					readInt();
					source.readUnsignedByte();
					readInt();
					break;
				case 0x32://hasnext2
					source.readUnsignedInt();
					source.readUnsignedInt();
					break;
				case 0x0c://ifnlt
				case 0x0d://ifnle
				case 0x0e://ifngt
				case 0x0f://ifnge
				case 0x10://jump
				case 0x11://iftrue
				case 0x12://iffalse
				case 0x13://ifeq
				case 0x14://ifne
				case 0x15://iflt
				case 0x16://ifle
				case 0x17://ifgt
				case 0x18://ifge
				case 0x19://ifstricteq
				case 0x1a://ifstrictne
					source.position += 3;//read sign 24
					break;
				case 0x1b://lookupswitch
					source.position += 3;//read sign 24
					var count:uint = readInt();
					source.position += (count + 1) * 3;
					break;
				case 0x24://pushbyte
					source.readUnsignedByte();
					break;
				case 0xd8://未知opcode
source.position = endPos;
					break;
				default:
					trace("opcode not handled! 0x"+opcode.toString(16));
			}
			if(source.position < endPos){
				arguments.callee(endPos);
			}else if(source.position > endPos){
				trace("error occur");
				source.position = endPos;
			}
		}
	}
}