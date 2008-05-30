/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.data {
	import flash.utils.IExternalizable;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.net.registerClassAlias;
		import flash.utils.ByteArray;
	import AS3;
	public dynamic class ArrayY  implements IExternalizable {
		private static const REG:* = registerClassAlias("com.troyworks.data.ArrayY",ArrayY);
		[RemoteClass(alias="com.troyworks.data.ArrayY")]
		public static const serialVersionUID:Number = 1;
		private var a:Array = new Array();
		// private const dataType:Class;
		 
		 
		public function ArrayY() { 
			//super();
		}
/*		AS3 override  function push(...args):uint{
	   //     for (var i:* in args)
        //{
           // if (!(args[i] is dataType))
           // {
             //   args.splice(i,1);
           // }
      //  }
			return (super.push.apply(this, args));
		}*/
		public function push(...args):uint{
			return a.push(args);
		}
		public function clone():ArrayY
		{
		var myBA:ByteArray = new ByteArray();
		myBA.writeObject(this);
		myBA.position = 0;
		return(myBA.readObject());
		}
		public function readExternal(input:IDataInput):void
		{
			
		//	var d:Object = input.readObject();
			
			//var sv:Number = d["serialVersionUID"] as Number ;
			var sv:Number = input.readObject() as Number ;
			trace("readExternal " + sv);
			/////////////// COMMON TO ALL VERSIONS ///////////////////////////
/*			if(serialVersionUID == 1 || serialVersionUID == 2 || serialVersionUID == 3){
				 name = d["name"] ;
				 trace("collection name" + name);
				trace("collection? " + d["c"]  + " " );
			trace("readExternal " + getQualifiedClassName(d["c"]));	
			//	c =d["c"] as ArrayX;
			//	trace("collection " +c);
				
			}*/
		}
		public function writeExternal(output:IDataOutput):void
		{
			trace("writeExternal");
//			var d:Object = new Object();
//			d["serialVersionUID"] = serialVersionUID;
//			d["array"] = 
		//	d["name"] = name;
			
			//trace("writeExternal " + getQualifiedClassName(c));
		///	d["c"]= c;
			output.writeObject(serialVersionUID);
			output.writeObject(super);
		}
		public function sliceX(...args) : ArrayY {
			return null;
		}
		public function toString():String{
			return "ArrayY" + a.join(",");
		}
	}
	
}
