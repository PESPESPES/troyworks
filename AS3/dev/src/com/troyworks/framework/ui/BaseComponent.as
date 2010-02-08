package com.troyworks.framework.ui {	
	import com.troyworks.util.Trace;

	import flash.events.Event;

	import com.troyworks.core.cogs.CogEvent;
	import com.troyworks.core.cogs.CogSignal;
	import com.troyworks.core.cogs.Hsm;

	import flash.display.MovieClip;
	import flash.display.Sprite;

	/*
	* This serves as a base class that extends the Statemachine+ Event Engine and MovieClip
	* and adds common functionality to most components
	* like  access to preloading, eventDispatcher
	*
	* In addition it also operates in a late binding
	* separation of script and ui, similar to how linkage works
	* with components and clips in the library. The difference is that
	* this binding happens later,  courtesy of David Yangs prototype
	* chain hacking.
	*
	* This allows complete separation of code from
	* ui, and simpler than in using composition (passing in a reference)
	*
	* @author Troy Gardner
	* @version
	 */
	

	
	//parent chain: HsmfE (statemachine + events)->MovieClip->Object
	public class BaseComponent extends Hsm implements IHaveChildrenComponents {
		//public var app : IApplication;
		// the base component supports
		// preloading, transition in, active, transition out to inactive,
		// those that have status provide it
		public static var EVT_LOADED : String = "EVT_LOADED";
		public static var EVT_READY : String = "EVT_READY";
		public static var EVT_TRANSIN : String = "EVT_";
	
	
		public static var ASSETS_LOADED_SIG : CogSignal = CogSignal.getNextSignal("ASSETS_LOADED");
		public static var STAGE_RESIZE_SIG : CogSignal = CogSignal.getNextSignal("STAGE_RESIZE_EVT");
	
	// capture positions

	
		public var isFullScreenMode : Boolean = false;
		public var followStage : Boolean = true;
		public var hAlign : Boolean = false;
		public var vAlign : Boolean = false;
		public var centerMe : Boolean = false;
		public var mcbuttons : Array = new Array();
	
		public var codeGen : Number = -1;
		public var owner : IHaveChildrenComponents;
		public var isLoaded : Boolean;
		public var isReady : Boolean;

	
		public function BaseComponent(initialState : String = "s_initial", hsmfName : String = null, aInit : Boolean = false)
		{
			super (initialState, (hsmfName != null)?hsmfName+":BaseComponent":"BaseComponent");
			if(aInit){
				initStateMachine();
			}
		}
		public var _view : Sprite;
		
		public function set view( value : Sprite ) : void {
				if(_view != value){
		    	    _view = value;
			          dispatchEvent(new Event(Event.CHANGE, true, true));
		        }
		}
		
		public function get view( ) : Sprite {
		        return _view;
		}
		
		
		public function onLoad(init : Boolean = true) : void
		{
			
			//if(codeGen > -1){
			//	trace("ERROR " + import com.troyworks.util.codeGen.UIHelper.genCode(this, codeGen));
			//}
		//	trace (this.name + " AAAAAAAAAAAAAAAAAAABaseComponent.onLoadAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
			//		trace ("setting owidht " + _root.vid_mc.width + "  height" + _root.vid_mc.height);
		//TODO setup snapshot of dimensions	snapshotDimensions(this);
			isLoaded = true;
			
	//		if(owner == null){
	//			owner = IHaveChildrenComponents(parent);
	//		}
	
			//owner.onChildClipLoad(this);
		/*	if((hasInited == INIT_NOT_INITED) && (init == true || init == null)){
				//activate the statemachine
				super.init();	
			}*/
			dispatchEvent(ASSETS_LOADED_SIG.createPrivateEvent());
			if (followStage)
			{
				//TODO add listener to state resize				stage.addEventListener (this);
			}
		}
	
		public function onChildClipLoad(_mc : MovieClip) : void{
			/*	if(_mc is MCBackground){
	               
				}else if(_mc is MCButton){
				var btn : MCButton = MCButton(_mc);
				//	 trace("HIGHLIGHTG BaseComponent onChildClipLoad addingListenerFor " +btn.click_evt);
				btn.addEventListener(btn.click_evt, this, this.onChildClipEvent);
				mcbuttons.push(btn);
				}else if(_mc is MovieClip){
				
				}else if(_mc is TextField){
				
				}*/
		}
		//public function onChildClipReady(_mc : MovieClip) : void {
		//}
		public function onChildClipEvent(e : Object) : void{
			trace("000000000000000000000000000000000000000000000000000000");
			trace("0000000000000000000000000BaseComponent.onChildClipEvent00000000000000000000000000000");
			//trace(util.Trace.me(e, "evt ", false));
			trace("000000000000000000000000000000000000000000000000000000");
			trace("000000000000000000000000000000000000000000000000000000");
			trace("000000000000000000000000000000000000000000000000000000");
		}
	
		/*******************************************************
		 * for a given movie passed in capture it's x, y, width height, into 
		 * another object (defaults to the same)
		 * 
		 * Note this can get tricky.
		 * 
		 * There is the library representation of the item (scaleX = 100, scaleY = 100)
		 * There is the onscreen representation as when the item loads
		 * There is the scaled version of it
		 * The version of it with content inside of it (which distorts the width, height properties)
		 * When being used with a viewport.
		 */
		public static function snapshotDimensions(a_mc : MovieClip, to_mc : Object, override_width : Number, override_height : Number) : void {
			var s_mc : MovieClip = a_mc;
			to_mc = (to_mc == null)?a_mc:to_mc;
			//////Find the viewport on the content/////////////////////////
			// note that when a movie clip is exported from the library, a wrapper swf is created
			//
			var viewport : MovieClip = null;
			if (a_mc.viewport_mc == null) {
				for (var i:String in a_mc) {
					var b:Sprite = a_mc[i] as Sprite;
				//	trace(i+" = "+b);
					if (Object(b).viewport_mc != null) {
					//	trace("found viewport l1");
						viewport = Object(b).viewport_mc;
						break;
					}
				}
			} else {
				viewport = a_mc.viewport_mc;
			}
			/////Get the original dimension pre scaling and positioning ////////////
			if (viewport != null) {
				trace("has a clipping region!!!!!!!!!!!!!!");
				s_mc = viewport;
				//offset between viewport and published content.
				to_mc.vp_ox_offset = viewport.x;
				to_mc.vp_oy_offset = viewport.y;
				to_mc.vp_owidth = viewport.width;
				to_mc.vp_oheight = viewport.height;
				trace(" offset x "+viewport.x+" y "+viewport.y);
				//scale factor between viewport and actual (masked) movie dimensions (as mask shows all stuff on stage)
				
				to_mc.vp_owscale = viewport.width/a_mc.width;
				to_mc.vp_ohscale = viewport.height/a_mc.height;
				trace("vp_owscale " + to_mc.vp_owscale + "  " +viewport.width + "/" +a_mc.width ); 
				//
				to_mc._owidth = s_mc.width;
				to_mc._oheight = s_mc.height;
				to_mc._o_wh_asp = s_mc.width/s_mc.height;
				to_mc._o_hw_asp = s_mc.height/s_mc.width;
			} else {
				// NO viewport
				to_mc.vp_ox_offset = 0;
				to_mc.vp_oy_offset = 0;
				to_mc.vp_owscale = 1;
				to_mc.vp_ohscale = 1;
				to_mc.vp_owidth = s_mc.width;
				to_mc.vp_oheight = s_mc.height;
	
			}
			to_mc._ox = s_mc.x;
			to_mc._oy = s_mc.y;
			to_mc._owidth = s_mc.width;
			to_mc._oheight = s_mc.height;
			to_mc._oxscale = s_mc.scaleX;
			to_mc._oyscale = s_mc.scaleY;
			//actual height
			to_mc._oawidth = Math.round(to_mc.width / to_mc.scaleX*100);
			to_mc._oaheight = Math.round(to_mc.height / to_mc.scaleY*100);
	
			to_mc._o_wh_asp = s_mc.width/s_mc.height;
			to_mc._o_hw_asp = s_mc.height/s_mc.width;
			//trace( util.Trace.me(to_mc, "ERROR SNAPSHOT DIMENSIONS ", true));
			trace(" captureOriginalAspect "+to_mc._url+" "+to_mc.width);
		}
	/*	public function center() : void {
			//Center
			//	trace(this.name + "BaseComponent.center()" + stage.stageWidth + " " + stage.stageHeight  + " " + this.width + " " + this.height);
			this.x = (stage.stageWidth - this.width) / 2;
			this.y = (stage.stageHeight - this.height) / 2;
			//	trace("setting to x " + this.x + " y " + this.y);
			
		}*/
		public static function centerClipTo(still_mc : MovieClip, moving_mc : MovieClip, override_width : Number, override_height : Number, scaleW : Number, scaleH : Number) : void
		{
			//Center
			//	trace(this.name + "BaseComponent.center()" + stage.stageWidth + " " + stage.stageHeight  + " " + this.width + " " + this.height);
			var dw : Number = (isNaN(override_width))? still_mc.width:override_width;
			var dh : Number = (isNaN(override_height))? still_mc.height:override_height;
			var iw : Number = moving_mc.width /scaleW;
			var ih : Number = moving_mc.height/scaleH;
			
	//		trace("CENTERING  Moving: " + w + ", " + h +" "
			var resX : Number = 0;
			if(dw > iw){
				resX = (dw - iw) / 2;
			}else{
				resX = (iw - dw) / 2;
			}
			var resY : Number = 0;
			if(dh > ih){
				resY = (dh - ih) / 2;
			}else{
				resY = (ih - dh) / 2;
			}
			trace("CENTERING dw " + dw + " dh " + dh + " iw " + iw + " ih " + ih + "== resX " + resX + " resY " + resY);
			moving_mc.x = resX;
			moving_mc.y = resY;
			//	trace("setting to x " + this.x + " y " + this.y);
			
		}
		public function alignH(x : String, still_mc : MovieClip, moving_mc : MovieClip, snapToWholePixel : Boolean) : Number
		{
			trace ("alignH " + x + " " + still_mc + " " + moving_mc + " snap " + snapToWholePixel);
			var r : Number = 0;
			switch (x.toUpperCase ())
			{
				//assume that mask is at 0,0 so no xpos is needed
				case "CENTER" :
					r = (still_mc.width - moving_mc.width) / 2;
					break;
				case "RIGHT" :
					r = (still_mc.width - moving_mc.width);
					break;
				case "LEFT" :
				default :
					return 0;
			}
			if (snapToWholePixel)
			{
				return Math.round (r);
			}else
			{
				return r;
			}
		}
		public function alignV(y : String, still_mc : MovieClip, moving_mc : MovieClip, snapToWholePixel : Boolean) : Number
		{
		//	trace ("alignV " + y+ " " + still_mc + " " + moving_mc + " snap " + snapToWholePixel);
			var r : Number = 0;
			switch (y.toUpperCase ())
			{
				//assume that mask is at 0,0 so no ypos is needed
				case "MIDDLE" :
					r = (still_mc.height - moving_mc.height) / 2;
					break;
				case "BOTTOM" :
					r = (still_mc.height - moving_mc.height);
					break;
				case "TOP" :
				default :
					return 0;
			}
			if (snapToWholePixel)
			{
				return Math.round (r);
			}else
			{
				return r;
			}
		}
	/*	public static function scaleTo(still_mc : MovieClip, moving_mc : MovieClip , override_width : Number, override_height : Number, viewport_width : Number, viewport_height : Number) : void {
			trace("HIGHLIGHT scaleTo");
			trace ("stage.stageWidth " + stage.stageWidth + " still  mc " + still_mc.width + " moving  mc " + moving_mc.width + " override " + override_width);
			trace ("stage.stageHeight " + stage.stageHeight + " still  mc " + still_mc.height+ " moving  mc " + moving_mc.height+ " override " + override_height);
			////////////////////////////////////
			//  target to scalee's actual height 
			////////////////////////////////////
			var	t_w : Number = null;
			if(viewport_width == null){
				trace(" not using viewport");
				if(moving_mc._oawidth ==null){
					trace("using current actual width");
					t_w = moving_mc.width;
				}else{
					trace("using original actual width");
	
					t_w = moving_mc._oawidth;
				}
			}else{
				trace(" using viewport dimensions");
				t_w = viewport_width;
			};
			var t_h : Number = null;
			if(viewport_height == null){
				t_h = (moving_mc._oaheight ==null)?moving_mc.height:moving_mc._oaheight;
			}else{
				t_h =viewport_height;
			} 
			////////////////////////////////////
			//   desired height 
			////////////////////////////////////
			var dw : Number = override_width ;
			var dh : Number = override_height;
			var scaleW : Number = (viewport_width == null)?1: moving_mc.vp_owscale;
			var scaleH : Number = (viewport_height == null)?1: moving_mc.vp_ohscale;
	
		//	trace("  scaling W " + scaleW + "  H " + scaleH);
			var p_asp : Number = t_w/t_h;
			var p2_asp : Number = t_h/t_w;
			var still_asp : Number = override_width/override_height;
		//	if (this.isFullScreenMode)
			{
				//o_wh_asp and o_hw_asp are the original captured aspect ratio,
				//this is as captured from the IDE, and NOT the actionscript,
				//in order to get accurate onscreen representation.
				//scale to smallest dimension based on the relative aspect ratio
		//		trace("PHOTO DIMENSIONS w:" + t_w + " h:" + t_h + " asp " + p_asp);
		//		trace("DESIRED DIMENTSION w:" + dw + " h: " + dh + " asp "   + still_asp);
				var asRatios : Number = (p_asp /still_asp);
				trace ("aspect ratio " + asRatios + "  " + still_asp);
				var resizeAnyWay : Boolean = (asRatios==1) && t_w != dw; 
				if (asRatios>1 || resizeAnyWay )
				{
					trace ("resizing width first to:" + dw);
					moving_mc.width = dw/  scaleW;
					moving_mc.height = dw / p_asp / scaleH;
					moving_mc.x = 0;
					//centerClipTo (still_mc , moving_mc, dw, dh, scaleW, scaleH);
					center2(moving_mc, {width:dw, height:dh, x:0, y:0});
				} else if (asRatios<1)
				{
					trace ("resizing height first to:" + dh );
					moving_mc.width = dh / p2_asp / scaleW;
					moving_mc.height = dh / scaleH;
					moving_mc.x = 0;
					center2(moving_mc, {width:dw, height:dh, x:0, y:0});
				//centerClipTo (still_mc , moving_mc , dw, dh, scaleW, scaleH);
				} else
				{
					trace ("NOT resizing");
				}
				trace("HIGHLIGHTO scaleTo res:  " + moving_mc.width + "  " + moving_mc.height);
				//this.playerNav_mc.x = ((t_w - (this.playerNav_mc.width + this.playerNav_mc.logo_mc.width )) / 2) + this.playerNav_mc.logo_mc.width + 30 ;
				//			this.playerNav_mc.y = (t_h - this.playerNav_mc.height) / 2;
				
		//	} else
		//	{
		//		this.resetSizeAndPosition ();
			}
		}
	public static function center2(_mc:MovieClip, back_mc:Object):void {
		//Center
		trace("HIGHLIGHT center2");
		// See if they are referrign to Stage or a component or not.
		var w :Number= (back_mc.width != null) ? back_mc.width : back_mc.width;
		var h :Number= (back_mc.height != null) ? back_mc.height : back_mc.height;
		trace("w " + w + " h " + h);
		if (false) {
			//works with non scaled clips
			_mc.x = back_mc.x+((w-_mc.width)/2);
			_mc.y = back_mc.y+((h-_mc.height)/2);
		} else {
			//TODO: tring to figure out scaled clip center.
			// the scale factor between whe content (not the viewport)
			// was first loaded and where it is now.
			// want >1 if it's been scaled up.
			trace("mc.width " + _mc.width + " ow " + _mc._oawidth);
			var sxf:Number = _mc.width/_mc._oawidth;
			var syf:Number = _mc.height/_mc._oaheight;
			trace("sxf " + sxf + " syf " + syf);
			var x_offset:Number = (sxf*_mc.vp_ox_offset);
			var y_offset :Number= (syf*_mc.vp_oy_offset);
			trace("xoffset "+x_offset+" y offset "+y_offset);
			trace("_mc.vp_owidth " + _mc.vp_owidth + " " +  _mc.vp_oheight);
			var ww:Number = _mc.vp_owidth*sxf;
			var yy:Number = _mc.vp_oheight*syf;
			trace("ww " + ww + " yy " + yy);
			_mc.x = back_mc.x+((w-ww)/2)-x_offset;
			_mc.y = back_mc.y+((h-yy)/2)-y_offset;
				trace("resX " + _mc.x + " resY " + _mc.y);
			
		}
		//}
	}
		/*function scaleTo2(_mc : MovieClip, back_mc : MovieClip) : void {
			trace(_mc+" ScaleTo -> "+back_mc);
			//Scale
			var sw : Number = (back_mc.width != null) ? back_mc.width : back_mc.width;
			var sh : Number = (back_mc.height != null) ? back_mc.height : back_mc.height;
				if(_mc._o_wh_asp == null){
					
				}
			var asRatios = (sw/sh)/_mc._o_wh_asp;
			trace("aspect ratio "+asRatios+"  "+_mc._o_wh_asp);
			var resizeAnyWay = (asRatios==1) && sw != _mc.width; 
					if (asRatios>1 || resizeAnyWay ){
				trace("resizing by width first");
				_mc.width = sw/_mc.vp_owscale;
				_mc.height = sw/_mc._o_wh_asp/_mc.vp_ohscale;
				this.center(_mc, back_mc);
			} else if (asRatios>1) {
				trace("resizing by height ");
				_mc.width = sh/_mc._o_hw_asp/_mc.vp_owscale;
				_mc.height = (sh/_mc.vp_ohscale);
				this.center(_mc, back_mc);
			} else {
				trace("NOT resizing");
			}
		}*/
		/*public function scaleToStage(override_width : Number, override_height : Number) : void {
			trace ("stage.stageWidth " + stage.stageWidth + " mc " + this.width);
			trace ("stage.stageHeight " + stage.stageHeight + " mc " + this.height);
			//Scale
			var	sw : Number = (override_width == null)? stage.stageWidth: override_width;
			var sh : Number = (override_height == null)?stage.stageHeight: override_height;
		
		//	if (this.isFullScreenMode)
			{
				//o_wh_asp and o_hw_asp are the original captured aspect ratio,
				//this is as captured from the IDE, and NOT the actionscript,
				//in order to get accurate onscreen representation.
				//scale to smallest dimension based on the relative aspect ratio
				var asRatios : Number = (sw / sh) / this._o_wh_asp;
				trace ("aspect ratio " + asRatios + "  " + this._o_wh_asp);
				if (asRatios < 1 )
				{
					trace ("resizing width first");
					this.width = sw;
					this.height = sw / this._o_wh_asp;
					this.center ();
				} else if (asRatios > 1)
				{
					trace ("resizing height first" );
					this.width = sh / this._o_hw_asp;
					this.height = sh;
					this.center ();
				} else
				{
					trace ("NOT resizing");
				}
				//this.playerNav_mc.x = ((sw - (this.playerNav_mc.width + this.playerNav_mc.logo_mc.width )) / 2) + this.playerNav_mc.logo_mc.width + 30 ;
				//			this.playerNav_mc.y = (sh - this.playerNav_mc.height) / 2;
				
		//	} else
		//	{
		//		this.resetSizeAndPosition ();
			}
		}
		public function resetSizeAndPosition() : void
		{
			this.x = this._ox;
			this.y = this._oy;
			this.width = this._owidth;
			this.height = this._oheight;
		}*/
		//Stage Resize
		public function onResize() : void {
			trace("*********** STAGE_RESIZE A ***********");
			dispatchEvent(STAGE_RESIZE_SIG.createPrivateEvent());
			trace("*********** STAGE_RESIZE B ***********");
//TODO			if(centerMe){
//				trace("________CENTERING?++++++++");
//				this.center ();
	//		}
		}
		//similar to a hittest but doesn't consider clips blocking the view of the mouse
		// and allows for padding (both positive and negative)d, for proximity purposes.
		public function mouseIsOverMe(padding : Number = 0) : Boolean
		{
			return ((0 - padding) < this.view.mouseX && this.view.mouseX < (this.view.width + padding)) && ((0 - padding) < this.view.mouseY &&this.view.mouseY < (this.view.height + padding));
		}
		/////////////////////// LEVEL 0 STATES////////////////////////////
		
		/*..PSEUDOSTATE...............................................................*/
		public function s_initial(e : CogEvent) : Function
		{
			trace("************************* s_initial " + Trace.me(e, "CogEvent")+" ******************");
	//		onFunctionEnter ("s_initial-", e, []);
			switch(e.sig)
			{
				case SIG_INIT :
				{
					return s0_viewAssetsUnLoaded;
				}
			}
			return s_root;
		}
		/*.................................................................*/
		public function s0_viewAssetsUnLoaded(e : CogEvent) : Function
		{
			trace("************************* s0_viewAssetsUnLoaded " + Trace.me(e, "CogEvent")+" ******************");
			//this.onFunctionEnter ("s0_viewAssetsUnLoaded-", e, []);
			switch(e.sig)
			{
				case ASSETS_LOADED_SIG:{
					requestTran(s0_viewAssetsLoaded);
					return null;
				}
			}
			return s_root;
		}
		/*.................................................................*/
		public function s0_viewAssetsLoaded(e : CogEvent) : Function
		{
			//this.onFunctionEnter ("s0_viewAssetsLoaded-", e, []);
			switch(e.sig)
			{
				case SIG_EXIT :
				{
					requestTran(s0_viewAssetsUnLoaded);
					return null;
				}
				case SIG_INIT :
				{
					return s1_creatingView;
				}
			}
			return s_root;
		}
		//////////////////////// LEVEL 1 STATES////////////////////////////
		/*.................................................................*/
		public function s1_viewNotCreated(e : CogEvent) : Function
		{
		//	this.onFunctionEnter ("s1_viewNotCreated-", e, []);
		/*	switch(e.sig)
			{
	
			}*/
			return s0_viewAssetsLoaded;
		}	/*.................................................................*/
		public function s1_creatingView(e : CogEvent) : Function
		{
		//	this.onFunctionEnter ("s1_creatingView-", e, []);
			switch(e.sig)
			{
				case SIG_INIT :
				{
					return s1_viewCreated;
				}
			}
			return s0_viewAssetsLoaded;
		}
		/*.................................................................*/
		public function s1_viewCreated(e : CogEvent) : Function
		{
		//	this.onFunctionEnter ("s1_creatingView-", e, []);
			switch(e.sig)
			{
				case SIG_ENTRY :
				{
					isReady = true;
					return null;
				}
			}
			return s0_viewAssetsLoaded;
		}
		/*.................................................................*/
		public function s1_destroyingView(e : CogEvent) : Function
		{
		//	this.onFunctionEnter ("s1_destroyingView-", e, []);
		/*	switch(e.sig)
			{
			}*/ 
			return s0_viewAssetsLoaded;
		}
		}
	}