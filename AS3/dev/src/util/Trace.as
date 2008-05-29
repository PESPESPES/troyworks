package util { 
	 /*
	*  A utility for debugging to trace heirarchical objects upto 2 deep
	*  has a few options to turn on and off detail.
	*  Generally used in the form of
	*
	* trace(util.Trace.me(obj, 'MyObject', true));
	*
	* By putting it into a conventional trace it will be removed from the code when traces are omitted off.
	*
	*  first argument 'txt:String' is an optional user friendly name e.g. "MyFirstCar"
	*  second 'showNested:boolean' indicates whether or not to show children (by default off)
	*  second 'showType:boolean' indicates whether or not to show type information e.g.("String") (by default on)
	*  third 'showValue:boolean' indicates whether or not to show actual value (e.g. 42) (by default on)
	*
	*
	trace(util.Trace.me(obj, 'MyObject', true));
	trace(util.Trace.me(obj, 'MyObject', true, true, true));
	+-- a3:object = "test"
	+- a2:Array = -empty-
	+- a1:number = 42
	+- a12:string = "test"
	*
	* trace(util.Trace.me(obj, 'MyObject', true, true, false));
	* 		+- a15:object
	+-- b3:object
	+-- b2:object
	+-- b1:object
	+- a14:object
	+-- b1:object
	
	trace(util.Trace.me(obj, 'MyObject', true, false, false));
	[[[[ MyObject.displayObj() START  nested: true ]]]]
	+- a15
	+-- b3
	+-- b2
	+-- b1
	+- a14
	+-- b1
	
	* @author
	* @version
	*/
	/*
	* CODE:
	//
	ASSetPropFlags (this, ['treeTrace'] , 1, 0);
	// test
	obj = new Object ();
	obj.a1 = 42;
	obj.a2 = new Array ();
	obj.a2 [0] = new LoadVars ();
	obj.a2 [1] = new Sound ();
	obj.a3 = 'test';
	obj.a4 = 'test';
	obj.a5 = new Object ();
	obj.a6 = 'test';
	obj.a7  ()
	{
	};
	obj.a8 = 'test';
	obj.a9 = new Object ();
	obj.a9.b1 = new Object ();
	obj.a9.b2 = 'test';
	obj.a10 = new Object ();
	obj.a10.b1 = new Object ();
	obj.a10.b1.c1 = new Object ();
	obj.a10.b1.c1.d1 = new Object ();
	obj.a11 = new Object ();
	obj.a11.b1 = 'test';
	obj.a12 = 'test';
	obj.a13 = obj;
	// backreference-test
	obj.a14 = new Object ();
	obj.a14.b1 = obj.a14;
	// backreference-test
	obj.a15 = new Object ();
	obj.a15.b1 = new Object ();
	obj.a15.b2 = new Object ();
	obj.a15.b3 = new Object ();
	trace(util.Trace.me(obj, 'obj', true));
	//OUTPUTS
	[[[[ obj.displayObj() START  nested: true ]]]]
	+- a15:object = [object Object]
	+-- b3:object = [object Object]
	+-- b2:object = [object Object]
	+-- b1:object = [object Object]
	+- a14:object = [object Object]
	+-- b1:object = [object Object]
	+- a13:object = [object Object]
	+-- a15:object = [object Object]
	+-- a14:object = [object Object]
	+-- a13:object = [object Object]
	+-- a12:string = "test"
	+-- a11:object = [object Object]
	+-- a10:object = [object Object]
	+-- a9:object = [object Object]
	+-- a8:string = "test"
	+-- a6:string = "test"
	+-- a5:object = [object Object]
	+-- a4:string = "test"
	+-- a3:string = "test"
	+-- a2:Array = ,[object Object]
	+-- a1:number = 42
	+- a12:string = "test"
	+- a11:object = [object Object]
	+-- b1:string = "test"
	+- a10:object = [object Object]
	+-- b1:object = [object Object]
	+- a9:object = [object Object]
	+-- b2:string = "test"
	+-- b1:object = [object Object]
	+- a8:string = "test"
	+- a6:string = "test"
	+- a5:object = [object Object]
	+- a4:string = "test"
	+- a3:string = "test"
	+- a2:Array = ,[object Object]
	+-- 1:Sound = [object Object]
	+-- 0:LoadVars =
	+- a1:number = 42
	[[[[ obj.displayObj() END ]]]]
	*/
	import flash.media.Camera;
	import flash.net.LocalConnection;
	import flash.media.Microphone;
	import flash.display.MovieClip;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.SharedObject;
	import flash.media.Sound;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.media.Video;
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	import flash.net.XMLSocket;
	public class Trace {
		public static var history : Array = null;
		public static var isTop : Boolean = false;
		public static var IDz : Number = 0;
		public static var depth : Number = 0;
		/**************************************
		 * Useful for eliminating infinite loops when
		 * Arrays contain circular references.
		 */
		public static var SKIP_ARRAYS : Boolean = false;
		public function Trace()
		{
		}
		////////////////////////////////////////////////////////////////////////
		//Object Debugging function
		////////////////////////////////////////////////////////////////////////
		public static function me(objStruct : Object, txt : String, showNested : Boolean, showType : Boolean, showValue : Boolean) : String
		{
			depth = 0;
		//	trace("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
			var res : Array = Trace.meAsArray(objStruct, txt, showNested, showType, showValue, depth);
			//trace(res);
			depth = 0;
			return res.join ('\r');
		};
		public static function instancesOf(aObj : Object, class1 : Object, class2 : Object, class1Name : String, class2Name : String) : String{
			trace("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
			trace("XXXXXXXXXXXXX Listing Signals and Events XXXXXXXXXXXXXXXXXXXXXXX");
			trace("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
			trace("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
			var res = new Array();
			for(var i in aObj){
				trace(" i " + i + " " + aObj[i]);
				var obj : Object = aObj[i];
				if(obj is class1){
					trace(class1Name + " " + obj);
				}else if(obj is class2){
					trace(class2Name + " " + obj);
				}
			}
			return res.join("\r");
		}
		public static function engageLoopCheck() : void{
			trace("000000000000000000000000000000000000000000000000000000");
			trace("000000000000000000000000000000000000000000000000000000");
			trace("000000000000000000000000000000000000000000000000000000");
			trace("000000000000000000000000000000000000000000000000000000");
			trace("000000000000000000000000000000000000000000000000000000");
			trace("000000000000000000000000000000000000000000000000000000");
			if(history == null){
				history = new Array();
			}
		}
		public static function disEngageLoopCheck() : void{
			trace("111111111111111111111111111111111111111111111");
			trace("111111111111111111111111111111111111111111111");
			trace("111111111111111111111111111111111111111111111");
			trace("111111111111111111111111111111111111111111111");
			trace("111111111111111111111111111111111111111111111");
			trace("111111111111111111111111111111111111111111111");
			history = null;
		}
	
		public static function meAsArray(objStruct : Object, txt : String, showNested : Boolean, showType : Boolean, showValue : Boolean) : Array{
			//this is used to prevent infinite loops
			var res = new Array ();
			if(objStruct.$$_id_ == null){
				objStruct.$$_id_ = IDz++;
				_global.ASSetPropFlags (objStruct, "$$_id_", 1);
			//	trace("issued a new ID + " + objStruct.$$_id_ + " " + objStruct._id_);  
			}
		//	trace(objStruct._id_ +"  " + objStruct.$$_id_ +" AA \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\");
			if(history != null){
				var hitLoop : Boolean = false;
				var t1 : Boolean = (objStruct == null);
				var t2 : Boolean = (objStruct == undefined);
				var t3 : Boolean = (typeof(objStruct) == "object");
				var cnt : Number = 0;
			if( !t1 && !t2 ||  t3 ){
					for(var i in history){
						trace("   " + cnt++ + " history check of " + i ); 
					//check to make sure we aren't looping
						var com = history[i].$$_id_;
					if(com === objStruct.$$_id_){
							trace(i + "ERRROR HIT INFINITE LOOP With TraceID " + " " +  com + " _id_: " + history[i]._id_ + " at " + cnt);
						//res.push("hit circular reference");
						throw new Error("Trace.me hit circular reference");
							hitLoop = true;
							return res;
						
					}
			}
			if(history != null){
			//	trace("----adding to history.add(" + objStruct._id_ +":"+ getExtendedType(objStruct)+")  #" + history.length);
						history.push(objStruct.$$_id_);
			}
			}else {
			//	trace(" NOT adding to history " + objStruct._id_ +":"+ getExtendedType(objStruct)+ " t1 " + t1 + " t2 " + t2 + " t3 " + t3 );
			//	return res;
			}
			}
			var text = (txt == null) ? "" : txt;
			res.push ("[[[[ " + text + ".displayObjmeAsArray() START  nested: " + showNested + " ]]]]");
		//trace("11b " + objStruct._id_);
	
			for (var name:String in objStruct)
			{
				//trace("11b2 "+  objStruct._id_ + " name " + name);
				var n = objStruct [name];
				//trace(" 11b3  "+  objStruct._id_ +" " +  n + " name " + name);
	
	
	//			trace("  11b4 " +  objStruct._id_ +" " + name +" " + n);
				var l = Trace.buildLine ("\t\t+- ", n, name, showNested, showType, showValue);
		//		trace("   line " + l);
				res.push (l);
				// trace("showing nested?: " + showNested);
				if (showNested)
				{
					for (var prop in objStruct [name])
					{
						var p = objStruct [name][prop];
						var m = Trace.buildLine ("\t\t\t+-- " , p, prop, showNested, showType, showValue);
			//			trace("    line2 "+ m);
						res.push (m);
					}
				}
			}
	//		trace(objStruct._id_ +"   ZZ /////////////////////////////////////////////////");
			res.push ("   [[[[ " + text + ".displayObjmeAsArray() END ]]]]");
			return res;
		} 
		//Since some logging utilities don't respect line breaks, out put them
		// each line by line.
		public static function meAsArrayToConsole(objStruct : Object, txt : String, showNested : Boolean, showType : Boolean, showValue : Boolean) : Array{
			var res : Array = Trace.meAsArray(objStruct, txt, showNested, showType, showValue);
			for (var i : Number = 0; i < res.length; i++) {
				trace(res[i]);
			}
			return res;
		}
	
		public static function buildLine(prefix:String, obj:Object, name:String, showNested:Boolean, showType:Boolean, showValue:Boolean) : String
		{
			var res:String = "";
			var etype:String = getExtendedType (obj);
			var tn:String = (showType == false) ?"" : ":" + etype;
			var sn:String = null;
			
			if(SKIP_ARRAYS && etype != "Array"){
				sn = "-skipped array";
			}else{
				sn  = obj.toString();
			}
			if (sn == "")
			{
				sn = "-empty-";
			}
			if (tn == "string")
			{
				res = (prefix + name + tn + ((showValue == false) ?"" : " = \"" + sn + "\""));
			} else
			{
				res = (prefix + name + tn + ((showValue == false) ?"" : " = " + sn + ""));
			}
			return res;
		}
		public static function me2(aObj1 : Object, aObj2 : Object, str:String) : String{
			var res:Array = new Array();
			res.push(aObj1.toString() + ":"+getExtendedType(aObj1));
			res.push(" " + str + " ");
			res.push(aObj2.toString() + ":"+getExtendedType(aObj2));
	
			return res.join(""); 
		}
		public static function getExtendedType(pObj : Object) : String
		{
			if (typeof (pObj) == 'string')
			return 'string';
			if (typeof (pObj) == 'number')
			return 'number';
			if (typeof (pObj) == 'movieclip'){
				var _mc:MovieClip = MovieClip(pObj);
			 	return 'movieclip' + " " + _mc.currentFrame +"/"+_mc.totalFrames + "@"+ _mc.getDepth() + " x "+ _mc.x + "," +_mc.y + " w" + _mc.width + " h" +_mc.height;
			}
			if (typeof (pObj) == 'boolean')
			return 'boolean';
			if (typeof (pObj) == 'function')
			return 'function';
			//
			if (pObj is Array)
			return 'Array';
			if (pObj is Sound)
			return 'Sound';
			if (pObj is XMLDocument)
			return 'Xml';
			if (pObj is XMLNode)
			return 'XMLNode';
			if (pObj is XMLSocket)
			return 'XMLSocket';
			if (pObj is LoadVars)
			return 'LoadVars';
			if (pObj is Color)
			return 'Color';
			if (pObj is NetConnection)
			return 'NetConnection';
			if (pObj is NetStream)
			return 'NetStream';
			if (pObj is Camera)
			return 'Camera';
			if (pObj is Microphone)
			return 'Microphone';
			if (pObj is SharedObject)
			return 'SharedObject';
			if (pObj is LocalConnection)
			return 'LocalConnection';
			if (pObj is Date)
			return 'Date';
			if (pObj is Button)
			return 'Button';
			if (pObj is TextField)
			return 'TextField';
			if (pObj is TextFormat)
			return 'TextFormat';
			if (pObj is Video)
			return 'Video';
			//if (pObj is  Cookie) return 'cookie';
			//
			if (pObj.strClassName != undefined)
			return pObj.strClassName;
			// anchor for own classNames
			//
			return typeof (pObj);
		};
		/***********************************************
		 *  This is used to look at the arguments passed 
		 *  into a function
		 *  
		 *  it's especially useful in conjunction with Object.watch
		 *  var tracer = util.Trace.getArgumentsTracer();
		 *  		this.watch("aVariableName", tracer);
		 */
		public static function getArgumentsTracer() : Function{
			var tracer : Function = function(){
				trace("Tracer " + util.Trace.me(arguments, "args", true));
			};
			return tracer;
		}
	}
	
}