/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.ui {

	public class DisplayObjectSnapShot implements IDisplayObjectSnapShot{
		// capture positions
		private var _rotation : Number;
		private var _x : Number;
		private var _y : Number;
		private var _width : Number;
		private var _height : Number;
		private var _scaleX : Number;
		private var _scaleY : Number; 
		
		// capture positions
		private var _orotation : Number;
		private var _ox : Number;
		private var _oy : Number;
		private var _owidth : Number;
		private var _oheight : Number;
		private var _oscaleX : Number;
		private var _oscaleY : Number; 
		//actual height
		private var _oawidth : Number;
		private var _oaheight : Number;
	
		private var _owhasp : Number;
		private var _ohwasp : Number;
		
		private var _hasViewport:Boolean;
		private var _vp_ocx_offset : Number;
		private var _vp_ocy_offset : Number;
		private var _vp_ox_offset : Number;
		private var _vp_oy_offset : Number;
		private var _vp_owscale : Number;
		private var _vp_ohscale : Number;
		private var _vp_owidth : Number;
		private var _vp_oheight : Number;
		
		public function DisplayObjectSnapShot (){
			
		}
		public function get rotation (): Number{ return _rotation;}
		public function set rotation (val:Number): void{ _rotation = val;}
		
		public function get x (): Number{ return _x;}
		public function set x (val:Number): void{ _x = val;}
		public function get y (): Number{ return _y;}
		public function set y (val:Number): void{ _y = val;}
		
		public function get width (): Number{ return _width;}
		public function set width (val:Number): void{ _width = val;}
		public function get height (): Number{ return _height;}
		public function set height (val:Number): void{ _height = val;}
		public function get scaleX (): Number{ return _scaleX;}
		public function set scaleX (val:Number): void{ _scaleX = val;}
		public function get scaleY (): Number{ return _scaleY;}
		public function set scaleY (val:Number): void{ _scaleY = val;}
		///////////////////////////////////
		public function get orotation (): Number{ return _orotation;}
		public function set orotation (val:Number): void{ _orotation = val;}
		public function get ox (): Number{ return _ox;}
		public function set ox (val:Number): void{ _ox = val;}
		public function get oy (): Number{ return _oy;}
		public function set oy (val:Number): void{  _oy = val;}
		public function get owidth (): Number{ return _owidth;}
		public function set owidth (val:Number): void{ _owidth = val;}
		public function get oheight (): Number{ return _oheight;}
		public function set oheight (val:Number): void{ _oheight = val;}
		public function get oxscale (): Number{ return _oscaleX;}
		public function set oxscale (val:Number): void{ _oscaleX = val;}
		public function get oyscale (): Number{ return _oscaleY;} 
		public function set oyscale (val:Number): void{ _oscaleY = val;}
		//actual height
		public function get oawidth (): Number{ return _oawidth;}
		public function set oawidth(val:Number): void{ _oawidth = val;}
		public function get oaheight (): Number{ return _oaheight;}
		public function set oaheight (val:Number): void{ _oaheight = val;}
		public function get o_wh_asp (): Number{ return _owhasp;}
		public function set o_wh_asp (val:Number): void{ _owhasp = val;}
		public function get o_hw_asp (): Number{ return _ohwasp;}
		public function set o_hw_asp (val:Number): void{ _ohwasp = val;}
		
		/////////////// VIEWPORT ////////////////////
		public function get hasViewport (): Boolean{ return _hasViewport;}
		public function set hasViewport (val:Boolean): void{ _hasViewport = val;}
		
		public function get vp_ocx_offset (): Number{ return _vp_ocx_offset;}
		public function set vp_ocx_offset (val:Number): void{ _vp_ocx_offset = val;}
		public function get vp_ocy_offset (): Number{ return _vp_ocy_offset ;}
		public function set vp_ocy_offset (val:Number): void{ _vp_ocy_offset = val;}
		
		public function get vp_ox_offset (): Number{ return _vp_ox_offset;}
		public function set vp_ox_offset (val:Number): void{ _vp_ox_offset = val;}
		public function get vp_oy_offset (): Number{ return _vp_oy_offset ;}
		public function set vp_oy_offset (val:Number): void{ _vp_oy_offset = val;}
		public function get vp_owscale (): Number{ return _vp_owscale;}
		public function set vp_owscale (val:Number): void{ _vp_owscale = val;}
		public function get vp_ohscale (): Number{ return _vp_ohscale ;}
		public function set vp_ohscale (val:Number): void{ _vp_ohscale = val;}
		public function get vp_owidth (): Number{ return _vp_owidth;}
		public function set vp_owidth (val:Number): void{ _vp_owidth = val;}
		public function get vp_oheight (): Number{ return _vp_oheight;}
		public function set vp_oheight (val:Number): void{ _vp_oheight = val;}
		public function toString():String{
			return "DisplayObjectSnapshot " + x +","+y+","+width+","+height;
		} 
	}
	
}
