package com.troyworks.controls.tbutton { 

	
	/**
	 * @author Troy Gardner
	 * has an optional label textfield
	 * this is a way of binding a skin (movie clip) to button behavior
	 * by one of two different methods, one is the stacked clips (more appropriate for things
	 * that need to be resized with end caps
	 *  and timeline, which is great for simple buttons, 
	 *  the frames should be [up][over][down][hit....][inactive][isEnabled...]
	 */
	import com.troyworks.framework.ui.BaseComponent;	
	
	import flash.text.TextField;	
	import flash.display.MovieClip;

	public class MCButton extends MovieClip {

		public var isReady:Boolean = false;
		protected var isEnabled:Boolean = true;
		protected var isMouseOver : Boolean;
		public var label:String;
		public var label_txt:TextField;
		// a utility 
		//public var initListeners:Array = new Array();
		//uses frame labels
		public static var TIMELINE_MC_BUTTON:Number = 0;
		public var upFrameLbl:String = "up";
		public var overFrameLbl:String = "over";
		public var downFrameLbl:String = "down";
		public var hitFrameLbl:String = "down";
		public var outFrameLbl:String = "up";
		public var disabledFrameLbl:String = "disabled";
		public var isEnabledFrameLbl:String = "up";
		
		//uses stacked clips for up, over, down states
		public static var STACKED_MC_BUTTON:Number = 1;
		public var up_mc:MovieClip;
		public var over_mc:MovieClip;
		public var down_mc:MovieClip;
		public var disabled_mc:MovieClip;
		//public var hit_mc:MovieClip;
		public static var EVTD_CLICK:String = "CLICK";
		public static var EVTD_ROLLOUT:String = "ROLLOUT";
		public static var EVTD_ROLLOVER:String = "ROLLOVER";
		public static var EVTD_DOWN:String = "DOWN";
		public static var EVTD_OUT:String = "OUT";
		public var click_evt:String = EVTD_CLICK;
	
			
		//used for only a single graphic
		public static var SINGLEFRAME_MC_BUTTON:Number = 2;
		 
		//defaults
		public var MC_ButtonStructure:Number = SINGLEFRAME_MC_BUTTON;
		private var _ox : Number;
		private var _oy : Number;
		private var isLoaded : Boolean;
		private var _owidth : Number;
		private var _oheight : Number;

		/*************************************
		 *  Constructor
		 */
		
		public function MCButton(initState : Function) {
		//	super(initState, name+":MCButton", false);
		//	trace(name+ ". New MC BUTTON");
		//	$tevD.debugTracesOn = true;
		}
		protected function onLoad():void{
		//TODO	isLoaded = true;
			trace(name+".MCButton.onLoad" );
			if(up_mc != null && over_mc != null && totalFrames ==1){
				trace("MC_ButtonStructure = STACKED_MC_BUTTON" + up_mc + " " + over_mc);
				MC_ButtonStructure = STACKED_MC_BUTTON;
				up_mc.x = 0;
				over_mc.x = 0;
				down_mc.x = 0;
				disabled_mc.x = 0;
				setUIState("UP");
			}else if(totalFrames > 3){
				trace("MC_ButtonStructure = TIMELINE_MC_BUTTON" );
				MC_ButtonStructure = TIMELINE_MC_BUTTON;
				
			}
			trace(name+".MCButton.onLoad "  + MC_ButtonStructure + " HIGHLIGHT " + totalFrames);
	
		//TODO	snapshotDimensions(this);
			 var n:String = String(name);
			//generate the label and the name and the event
			 var a:Number = n.indexOf("__");
			 var nm:String =null;
			 if(a > -1){
			  	nm=	n.substring(2, n.length);
			  	click_evt = nm;
			 }else {
			 	nm =n;
			 }
	
			this.label_txt.text = nm;
			//		 label = nm;
			 isEnabled = this.isEnabled;
			isReady = true;
		//TODO	owner.onChildClipLoad(this);
		
		//	this.init = true;
		}
		/*
			protected function initContent():void{
			textField_txt = createTextField("label_txt", 0, 0, 0, __width, __height);
			textField_txt.selectable = false;
			textField_txt.wordWrap = false;
			textField_txt.multiline = false;
			textField_txt.embedFonts = true;
			
			textFormat_tft = new TextFormat(_sFont, _nSize, _nColor);
			disableTextFormat_tft = new TextFormat(_sFont, _nSize, 0x666666);
			
			body = this.createEmptyMovieClip("body", -1);
			
			body.graphics.beginFill(0x333333, 0);
			body.graphics.moveTo(0, 0);
			body.graphics.lineTo(__width, 0);
			body.graphics.lineTo(__width, __height);
			body.graphics.lineTo(0, __height);
			body.graphics.lineTo(0, 0);
			body.graphics.endFill();
			
			isMouseOver = false;
			isEnabled = true;
			embedFont = true;
			textFormat = textFormat_tft;
			updateState();
			
			visible = true;
			initialized = true;	
		}*/
	
		protected function onReleaseHandler():void {
			trace(name+".MCButton.onReleaseHandler---------------------------");
			setUIState("OVER");
			trace("dispatch click " + click_evt);
	//TODO		TEventDispatcher.DEBUG_TRACES_ON = true;
//TODO			dispatchEvent( new MouseEvent(type:click_evt, target:this, index:hsmID, debug:true} );
		//			TEventDispatcher.DEBUG_TRACES_ON = false;
				
			//Q_dispatch(Hsmf.USER_SIG);
			trace(name+".MCButton.onReleaseHandler2222222222---------------------------");
		
		}
		protected function onReleaseOutsideHandler():void {
			trace(name+".MCButton.onReleaseOutsideHandler");
			setUIState("OUT");
	//TODO		dispatchEvent( {type:EVTD_OUT, target:this, index:hsmID} );
		}
		protected function onPressHandler():void {
			trace(name+".MCButton.onPressHandler");	
			setUIState("DOWN");
		//TODO	dispatchEvent( {type:EVTD_DOWN, target:this, index:hsmID} );
		}
		protected function onRollOverHandler():void {
			trace(name+".MCButton.onRollOverHandler");
			setUIState("OVER");
		//TODO	dispatchEvent( {type:EVTD_ROLLOVER, target:this, index:hsmID} );
			isMouseOver = true;
		}
		protected function onRollOutHandler() :void{
			trace(name+".MCButton.onRollOutHandler");
			setUIState("OUT");
		//TODO	dispatchEvent( {type:EVTD_ROLLOUT, target:this, index:hsmID} );
			isMouseOver = false;
		}
		override public function set enabled(val:Boolean) :void{
			var changed:Boolean =  (val != isEnabled);
			isEnabled = val;
			trace(name +".MCButton.setEnabled " + val);
		
			if((isLoaded && !isReady) || (isReady && changed)){
			if (isEnabled ) {
				//trace("enabling");
					setUIState();
			     //enable the events
/*				onPress = onPressHandler;
			    onRelease = onReleaseHandler;
				onReleaseOutside =onReleaseOutsideHandler;
				onRollOver = onRollOverHandler;
				onRollOut = onRollOutHandler;*/
				useHandCursor = true;
			} else {
				//trace("disabling");
				setUIState();
			     //disable everything
/*				delete(onPress);
			    delete(onRelease);
				delete(onReleaseOutside);
				delete(onRollOver);
				delete(onRollOut);*/
				useHandCursor = false;
			}
			}
			super.enabled = val;
		}
		protected function setSize(aWidth:Number, aHeight:Number):void{
			label_txt.width = aWidth;
			label_txt.height = aHeight;
			width = aWidth;
			height = aHeight;
		}
		public function setUIState(msg:String = null) : void {
			trace(name+".MCButton.setUIState."+msg + " isEnabled " + isEnabled + " type " +MC_ButtonStructure);
			if(isEnabled){
				////////////// ENABLED ///////////////////////////////
				if (msg == null || msg == "UP") {
					trace("going to isEnabled");
					switch(MC_ButtonStructure){
						case STACKED_MC_BUTTON:{
							trace("via stackedbutton");
							up_mc.visible = true;
							over_mc.visible = false;
							down_mc.visible = false;
							disabled_mc.visible = false;
							break;
						}
						case TIMELINE_MC_BUTTON:{
							
							gotoAndPlay(upFrameLbl);
							trace("via timline line to Frame:" + upFrameLbl + " at Frame: " + currentFrame);
							break;
						}
						case SINGLEFRAME_MC_BUTTON:{
							trace("via singleframe");
							alpha = 100;
					//TODO		resetSizeAndPosition();
							break;
						}
						default:{
						//TODO	REQUIRE(false, "ERROR in MCButton.setUIState, invalid MC_ButtonStructure: " + MC_ButtonStructure);
						}
					}
				} else if (msg == "OVER") {
					switch(MC_ButtonStructure){
						case STACKED_MC_BUTTON:{
							up_mc.visible = false;
							over_mc.visible = true;
							down_mc.visible = false;
							disabled_mc.visible = false;
							break;
						}
						case TIMELINE_MC_BUTTON:{
							gotoAndPlay(overFrameLbl);
							break;
						}
						case SINGLEFRAME_MC_BUTTON:{
				//			trace("single frame _________________________________");
				
							this.x = _ox-2;
							this.y = _oy-2;
							this.width = this._owidth + 4;
							this.height =this._oheight + 4;
							break;
						}	
					}
				} else if (msg == "DOWN") {
					switch(MC_ButtonStructure){
						case STACKED_MC_BUTTON:{
							up_mc.visible = false;
							over_mc.visible = false;
							down_mc.visible = true;
							disabled_mc.visible = false;
							break;
						}
						case TIMELINE_MC_BUTTON:{
							gotoAndPlay(downFrameLbl);
							break;
						}
						case SINGLEFRAME_MC_BUTTON:{
							this.x = _ox + 1;
							this.y = _oy + 1;
							break;
						}	
					}
				} else if (msg == "OUT"){
					switch(MC_ButtonStructure){
						case STACKED_MC_BUTTON:{
							up_mc.visible = true;
							over_mc.visible = false;
							down_mc.visible = false;
							disabled_mc.visible = false;
							break;
						}
						case TIMELINE_MC_BUTTON:{
							gotoAndPlay(outFrameLbl);
							break;
						}
						case SINGLEFRAME_MC_BUTTON:{
						//TODO	resetSizeAndPosition();
							break;
						}	
					}
				}				
			}else{
				///////////////NOT ENABLED ////////////////////////////////////
					switch(MC_ButtonStructure){
						case STACKED_MC_BUTTON:{
					
							if(disabled_mc == null){
								up_mc.visible = true;
								up_mc.alpha = 30;
					
							}else{
								up_mc.visible = false;
								disabled_mc.visible = true;
							}					
							over_mc.visible = false;
							down_mc.visible = false;
							break;
						}
						case TIMELINE_MC_BUTTON:{
						
							gotoAndPlay(disabledFrameLbl);
							break;
						}
						case SINGLEFRAME_MC_BUTTON:{
							alpha =30;
							break;
						}	
					}
			}
			
		}
	
	}
}