/**
* The sole job of this class to help serialize and deserialize BitmapData to streams
* as they don't work by default.
*
* @author Default
* @version 0.1
*/

package com.troyworks.core.persistance.wrapper {
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import flash.net.registerClassAlias;
	
	public class BitmapDataWrapper {
		
		public var height:Number;
		public var width:Number;
		public var bA:ByteArray;
		private static const REG:* = registerClassAlias(" com.troyworks.prevayler.wrapper.BitmapDataWrapper",BitmapDataWrapper);
		
		
		public function BitmapDataWrapper(bitmapData:BitmapData= null) {
			trace("new BitmapDataWrapper " + bitmapData);
			if(bitmapData != null){
				height = bitmapData.height;
				width = bitmapData.width;
				bA = new ByteArray();
				for (var i:uint=0; i<bitmapData.width; i++) {
					for (var j:uint=0; j<bitmapData.height; j++) {
						//trace("writing " + i + " " + j  + " " + curBitmapData.getPixel( i, j ));
						bA.writeUnsignedInt( bitmapData.getPixel( i, j ) );
					}
				}
			}
		}
		
		public function getBitMapData():BitmapData{
			 if(bA != null){
				var bd : BitmapData = new BitmapData( width, height );
				for (var i:uint=0; i<bd.width; i++) {
					for (var j:uint=0; j<bd.height; j++) {
						//trace("reading " + i + " " + j  + " " + curBitmapData.getPixel( i, j ));
						bd.setPixel( i, j, bA.readUnsignedInt() );
					}
				}
				
				trace("getBitMapData " + bd);
				return bd;
		   } else{
			   				trace("getBitMapData invalid " + bd);
			   return null;
		   }
		}
		
	}
	
}
