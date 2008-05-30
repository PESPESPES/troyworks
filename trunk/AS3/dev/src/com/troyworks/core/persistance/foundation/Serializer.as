/**
* A utility to help serialize custom classes in
* It's designed to be used with IExternalizeable
* 
* public function writeExternal(output:IDataOutput):void
		{
		
//instead of			output.writeObject(d);       
			Serializer.writeExternal(d, output);
		}
* @author Default
* @version 0.1
*/

package com.troyworks.core.persistance.foundation {
	import com.troyworks.core.persistance.wrapper.BitmapDataWrapper;	
	
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	
	public class Serializer {
		
		public static function writeExternal(obj:*, stream:IDataOutput):void{
			if(obj is BitmapData){
				stream.writeObject(new BitmapDataWrapper(BitmapData(obj)));
			}else{
				stream.writeObject(obj);
			}
		}
		public static function readExternal( stream:IDataInput):*{
			var obj:Object = stream.readObject();
			if(obj is BitmapDataWrapper){
				return BitmapDataWrapper(obj).getBitMapData();
			}
			return obj;
		}
	}
	
}
