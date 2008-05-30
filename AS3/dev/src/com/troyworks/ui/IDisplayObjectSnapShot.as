/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.ui {

	public interface IDisplayObjectSnapShot {
		function get rotation (): Number;
		function set rotation (val:Number): void;
		function get x (): Number;
		function set x (val:Number): void;
		function get y (): Number;
		function set y (val:Number): void;
		function get width (): Number;
		function set width (val:Number): void;
		function get height (): Number;
		function set height (val:Number): void;
		function get scaleX (): Number;
		function set scaleX (val:Number): void;
		function get scaleY (): Number;
		function set scaleY (val:Number): void;
		///////////////////////////////////
		function get orotation (): Number;
		function set orotation (val:Number): void;
		function get ox (): Number;
		function set ox (val:Number): void;
		function get oy (): Number;
		function set oy (val:Number): void;
		function get owidth (): Number;
		function set owidth (val:Number): void;
		function get oheight (): Number;
		function set oheight (val:Number): void;
		function get oxscale (): Number;
		function set oxscale (val:Number): void;
		function get oyscale (): Number; 
		function set oyscale (val:Number): void;
		//actual height
		function get oawidth (): Number;
		function set oawidth(val:Number): void;
		function get oaheight (): Number;
		function set oaheight (val:Number): void;
		function get o_wh_asp (): Number;
		function set o_wh_asp (val:Number): void;
		function get o_hw_asp (): Number;
		function set o_hw_asp (val:Number): void;
		
		/////////////// VIEWPORT ////////////////////
		function get hasViewport():Boolean;
		function set hasViewport(val:Boolean):void;
		function get vp_ocx_offset (): Number;
		function set vp_ocx_offset (val:Number): void;
		function get vp_ocy_offset (): Number;
		function set vp_ocy_offset (val:Number): void;
		function get vp_ox_offset (): Number;
		function set vp_ox_offset (val:Number): void;
		function get vp_oy_offset (): Number;
		function set vp_oy_offset (val:Number): void;
		function get vp_owscale (): Number;
		function set vp_owscale (val:Number): void;
		function get vp_ohscale (): Number;
		function set vp_ohscale (val:Number): void;
		function get vp_owidth (): Number;
		function set vp_owidth (val:Number): void;
		function get vp_oheight (): Number;
		function set vp_oheight (val:Number): void;
		
	}
	
}
