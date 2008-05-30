package com.troyworks.ui.menus { 
	import com.troyworks.framework.ui.BaseComponent;
	import mx.transitions.Tween;
	import mx.transitions.easing.*;
	import flash.filters.BlurFilter;
	import com.troyworks.framework.loader.MCLoader;
	import com.troyworks.hsmf.AEvent;
	import com.troyworks.mediaplayer.ui.FramedMediaPlayer;
	/**
	 * @author Troy Gardner
	 */
	import flash.ui.Mouse;
	import flash.display.MovieClip;
	import flash.media.Sound;
	public class Table3DRotaryCarouselMenu extends BaseComponent {
		public var numOfItems : Number;
		public var radiusX : Number = 800;
		public var radiusY : Number = 305;
		public var centerX : Number = stage.stageWidth/2;
		public var centerY : Number = stage.stageHeight/2;
		public var speed : Number = 0.05;
		public var perspective : Number = 130;
		protected var lastMousePos : String;
		protected var login_mc : MovieClip;
		public var tooltip : MovieClip;
		protected var users_Clips : Array = new Array();
		protected var dataprovider : Array;
	
		protected var toolTipFollowClip : MovieClip;
		protected var toolTipEnabled : Boolean = false;
	
		public var curSelectedClip : Object;
	
		public var selectedItem : Object;
	
		protected var _xadj : Number;
		public var photos_mc : MovieClip;
		/*****************************************************
		 *  Constructor
		 */
		public function Table3DRotaryCarouselMenu(clip : MovieClip) {
			super(null, "Table3DCarousel", true);
		}
	
	
		function released() : void {
			Q_TRAN(s1_transitioningToForm);
		}
	
		function unReleased() : void {
			Q_TRAN(s1_transitionFromFormToCarousel);
			selectedItem = null;
		}
	
		
		/********************************
		* This configures the rotation
		* rate based on the mouses position
		* there are 3 basic zones,
		* left side, right side and center.
		* center is a slow/zero zone, setting to zero when crossing center.
		*/
		function onMouseMove() : void {
			if(mouseIsOverMe(10)){
			if (mouseX<(centerX-100 + _xadj)) {
				lastMousePos = "LEFT_SIDE";
				//trace("SPEED A");
				speed = (this.mouseX-(centerX-100 + _xadj))/2500;
			} else if (mouseX>(centerX+100 + _xadj)) {
				lastMousePos = "RIGHT_SIDE";
				//trace("SPEED B");
				speed = (this.mouseX-(centerX+100 + _xadj))/2500;
			} else {
				//trace("SPEED C "+speed);
				if (speed != 0) {
					if (lastMousePos == "LEFT_SIDE" && mouseX>centerX) {
						speed = 0;
					} else if (lastMousePos == "RIGHT_SIDE" && mouseX<centerX) {
						speed = 0;
					}
				}
			}
	
	
			}else{
				if(speed > 0){
					speed -= .005;
				}else if(speed <0){
					speed  += .005; 
				}
		/*		if(-.005 > speed && speed < .005){
					speed = 0;
				}*/
			}
			speed = Math.max(-.05, Math.min(speed, .05));
			trace("Speed " + speed);
		};
		public function moveToolTip() : void{
			if(toolTipEnabled  && toolTipFollowClip != null){
			//	trace("moveToolTip ENABLED" + tooltip.x );
				tooltip.x = toolTipFollowClip.x + 20;
				tooltip.y = toolTipFollowClip.y + 10;
				tooltip.alpha =100;
				tooltip.visible = true;
			}else{
			//	trace("moveToolTip NOT ENABLED");
				tooltip.x = stage.stageWidth+ 40;
				tooltip.visible =false;
				
			}
		}
		public function releaseToolTip() : void {
	//		trace("releaseToolTip");
			toolTipFollowClip = null;
			tooltip.visible =false;
			moveToolTip();
		}
	
		public function activateToolTip(_mc : MovieClip) : void {
		//	trace("activateToolTip");
			//if(toolTipEnabled){
			toolTipFollowClip = _mc;
			moveToolTip();
		//	}
		}
		/////////////////////////////////////////////////////////////////////////
		// STATE MACHINE CODE 
		/////////////////////////////////////////////////////////////////////////
	
		/*.................................................................*/
		function s0_viewAssetsLoaded(e : AEvent) : Function
		{
			this.onFunctionEnter ("s0_viewLoaded-", e, []);
			switch (e)
			{
				case ENTRY_EVT :
				{
					trace("000000000000000000000000000000000000000000000000000000");
					trace("000000000000000000000000000000000000000000000000000000");
					trace("000000000000000000000000000000000000000000000000000000");
					trace("0000000000000000000000CREATE STAGE ELEMENTS00000000000000000000000000000000");
					trace("000000000000000000000000000000000000000000000000000000");
					trace("000000000000000000000000000000000000000000000000000000");
							centerX = this.width/2;
			centerY = this.height/2;
				///////// CREATE STAGE ELEMENTS ///////////
				//------ deal with forms on scree -----
					login_mc.alpha = 0;
					login_mc.visible = false;
				//------ attach a tooltip -------------
					tooltip = this.attachMovie("tooltip", "tooltip", 10000);
					moveToolTip();
					return null;
				}
				case EXIT_EVT :
				{
	
					return null;
				}
				case INIT_EVT :
				{
					//------build the list of children icons on stage
					trace("creatingChildren-------------" + dataprovider.length);
					numOfItems = dataprovider.length;
					radiusX = 50*numOfItems+(40-numOfItems);
					radiusY = radiusX*.35;
					for (var i = 0; i<numOfItems; i++) {
	
						var usr:CarouselMenuDataProvider = CarouselMenuDataProvider(dataprovider[i]);
						trace(" creating user "+usr.getLabelText()+" "+usr.getThumbnailMediaPath());
						var t:FramedMediaPlayer = FramedMediaPlayer(this.photos_mc.attachMovie("PlaylistPhotoButton", "item"+i, i+1));
						if(i==0){
							_xadj = t.width/2;
							centerX +=  _xadj;
						}
						t.data = usr;
						Object(t).angle = i*((Math.PI*2)/numOfItems);
						Object(t).toolText = usr.getToolTipText();
						t.contentURL = usr.getThumbnailMediaPath();
						t.label = usr.getLabelText();
						t.contextMenu = this;
						t.x  = Math.cos(Object(t).angle)*radiusX+centerX;
						t.y = Math.sin(Object(t).angle)*radiusY+centerY;
						t.visible = false;
						users_Clips.push(t);
					}
					trace("Start Pulse ENTRY_EVT");
					startPulse(1000/3);
					return null;
				}
				case PULSE_EVT:
				{
					trace("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
					trace("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
					trace("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
					trace("aaaaaaaaaaaaaaaaas0_viewLoadedaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
					trace("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
					trace("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
					trace("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
					stopPulse();
					Q_TRAN(s1_animatingCarousel);
					return null;
				}
			}
			return s_top;
		}
		/*.................................................................*/
		function s1_animatingCarousel(e : AEvent) : Function
		{
			this.onFunctionEnter ("s1_animatingCarousel-", e, []);
			switch (e)
			{
				case ENTRY_EVT :
				{
					trace("bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb");
					trace("bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb");
					trace("bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb");
					trace("bbbbbbbbbbbbbbbbbbbbbs1_animatingCarousel	bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb");
					trace("bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb");
					trace("bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb");
					trace("Start Pulse ENTRY_EVT");
					toolTipEnabled = true;
					startPulse(1000/24);
					return null;
				}
				case EXIT_EVT :
				{
					toolTipEnabled = false;
					moveToolTip();
					stopPulse();
					return null;
				}
				case INIT_EVT :
				{
					return null;
				}
				case PULSE_EVT:
				{
				/////////// Animatee Carousel Clips /////////////
					for (var i : Number = 0; i < users_Clips.length; i++) {
						var c_CLip : MovieClip = users_Clips[i];
						c_CLip.x  = Math.cos(c_CLip.angle)*radiusX+centerX;
						c_CLip.visible = true;
						c_CLip.y = Math.sin(c_CLip.angle)*radiusY+centerY;
						var s = (c_CLip.y-perspective)/(centerY+radiusY-perspective);
						c_CLip.scaleX = c_CLip.scaleY=s*100;
						c_CLip.angle += this.speed;
						c_CLip.swapDepths(Math.round(c_CLip.scaleX)+100);
					}
					////////// Move ToolTip /////////////////////////
				//	if(toolTipEnabled){
					moveToolTip();
				//	}
					return null;
				}
			}
			return this.s1_viewCreated;
		}
			/*.................................................................*/
		function s1_transitioningToForm(e : AEvent) : Function
		{
			this.onFunctionEnter ("s1_transitioningToForm-", e, []);
			switch (e)
			{
				case ENTRY_EVT :
				{
					trace("released");
					//BONUS Section
					var sou : Sound = new Sound();
					sou.attachSound("sdown");
					sou.start();
					trace("START click on release "+util.Trace.me(this.parent, "looking for User", true));
					//////////////////////////////
					for (var i:Number = 0; i< users_Clips.length; i++) {
						var t : Table3DRotaryCarouselMenuItem = users_Clips[i];
						t.xPos = t.x;
						t.yPos = t.y;
						t.theScale = t.scaleX;
						//trace(i + " ---------------TRANSITIONG TO FORM--------------" + t + " " +  users_Clips.length);
						if (t != curSelectedClip) {
							////////////SHRINK AND FADE /////////////////////////////
							trace("//////////SHRINK AND FADE /////////////////////////////");
							var tw : Tween = new Tween(t, "scaleX", Strong.easeOut, t.scaleX, 0, 1, true);
							var tw2 : Tween = new Tween(t, "scaleY", Strong.easeOut, t.scaleY, 0, 1, true);
							var tw3 : Tween = new Tween(t, "alpha", Strong.easeOut, 100, 0, 1, true);
							t.setEnabled(false);
							t.visible = false;
						} else {
							trace("????????????????? TRANSITION TO THE FORM ??????????");
							login_mc.data = selectedItem;
							login_mc.onActivate();
							///////////MOVE THE SELECTED TO THE TOP LEFT //////////////
							var tw : Tween = new Tween(t, "scaleX", Strong.easeOut, t.scaleX, 100, 1, true);
							var tw2 : Tween = new Tween(t, "scaleY", Strong.easeOut, t.scaleY, 100, 1, true);
							var tw3 : Tween = new Tween(t, "x", Strong.easeOut, t.x, (login_mc.x - 20 - t._owidth), 1, true);
							var tw4 : Tween = new Tween(t, "y", Strong.easeOut, t.y, (login_mc.y - (login_mc.height-t._oheight)/2 + 20), 1, true);
							/////////////TRANSITION IN THE FORM ///////////////////////
							login_mc.visible = true;
							var tw5 : Tween = new Tween(login_mc, "alpha", Strong.easeOut, 0, 100, 1, true);
							trace("START -------- creating PULSE");
							tw4.onMotionStopped = this.createCallback(PULSE_EVT, true);
						
						}
				
					}
					return null;
				}
				case EXIT_EVT :
				{
	
					return null;
				}
				case INIT_EVT :
				{
					return null;
				}
				case PULSE_EVT:
				{
					trace("START -------- going to Form");
					Q_TRAN(s1_onForm);
					return null;
				}
			}
			return this.s1_viewCreated;
		}
			/*.................................................................*/
		function s1_onForm(e : AEvent) : Function
		{
			this.onFunctionEnter ("s1_onForm-", e, []);
			switch (e)
			{
				case ENTRY_EVT :
				{
					trace("000000000000000000000000000000000000000000000000000000");
					trace("000000000000000000000000000000000000000000000000000000");
					trace("000000000000000000onTransitionedToForm000000000000000000000000000000000000");
					trace("000000000000000000000000000000000000000000000000000000");
					trace("000000000000000000000000000000000000000000000000000000");
					trace("000000000000000000000000000000000000000000000000000000");
					curSelectedClip.isSelected = true;
					//MovieClip(curSelectedClip).swapDepths()
					curSelectedClip.setEnabled(true, true);
					return null;
				}
				case EXIT_EVT :
				{
					return null;
				}
				case INIT_EVT :
				{
					return null;
				}
			}
			return this.s1_viewCreated;
		}
			
		/*.................................................................*/
		function s1_transitionFromFormToCarousel(e : AEvent) : Function
		{
			this.onFunctionEnter ("s1_transitionFromFormToCarousel-", e, []);
			switch (e)
			{
				case ENTRY_EVT :
				{
					var sou : Sound = new Sound();
					sou.attachSound("sdown");
					sou.start();
					var tw : Tween = new Tween(login_mc, "alpha", Strong.easeOut, 100, 0, 0.5, true);
					for (var i = 0; i< users_Clips.length; i++) {
						var t : MovieClip = users_Clips[i];
						t.visible = true;
					if (t != curSelectedClip) {
							var tw1 : Tween = new Tween(t, "scaleX", Strong.easeOut, 0, t.theScale, 1, true);
							var tw2 : Tween = new Tween(t, "scaleY", Strong.easeOut, 0, t.theScale, 1, true);
							var tw3 : Tween = new Tween(t, "alpha", Strong.easeOut, 0, 100, 1, true);
					} else {
							var tw1 : Tween = new Tween(t, "scaleX", Strong.easeOut, 100, t.theScale, 1, true);
							var tw2 : Tween = new Tween(t, "scaleY", Strong.easeOut, 100, t.theScale, 1, true);
							var tw3 : Tween = new Tween(t, "x", Strong.easeOut, t.x, t.xPos, 1, true);
							var tw4 : Tween = new Tween(t, "y", Strong.easeOut, t.y, t.yPos, 1, true);
							tw4.onMotionStopped = createCallback(PULSE_EVT, true);
						
						//startPulse(1000);
					}
				}
					return null;
				}
				case EXIT_EVT :
				{
					login_mc.visible = false;
					return null;
				}
				case INIT_EVT :
				{
					return null;
				}
				case PULSE_EVT:
				{
					curSelectedClip.isSelected = false;
					curSelectedClip = null;
					for (var j = 0; j<numOfItems; j++) {
						var t : MovieClip = users_Clips[j];
						t.setEnabled(true, false);
					}
					stopPulse();
					Q_TRAN(s1_animatingCarousel);
					return null;
				}
			}
			return this.s1_viewCreated;
		}
			
	}
}