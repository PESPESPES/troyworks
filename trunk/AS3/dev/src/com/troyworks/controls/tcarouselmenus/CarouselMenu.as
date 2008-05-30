package com.troyworks.ui.menus { 
	/**
	 * @author Troy Gardner
	 */
	import com.troyworks.data.ArrayX;
	import com.troyworks.data.WindowIterator;
	import com.troyworks.framework.ui.BaseComponent;
	import com.troyworks.hsmf.AEvent;
	import com.troyworks.data.RandomizedPlayList;
	import com.troyworks.geom.d1.CompoundLine1D;
	import com.troyworks.geom.d1.Line1D;
	import com.troyworks.mediaplayer.ui.FramedMediaPlayer;
	import com.troyworks.ui.Bounds2;
	
	import flash.ui.Mouse;
	import flash.display.MovieClip;
	import flash.xml.XMLDocument;
	public class CarouselMenu extends BaseComponent {
		public var playlistvisiblewindow_mc : MovieClip;
		public var clipPadding : Number = 3;
		public var clippadding : Number = 5;
		//playlist UI clips
		public var menuUIItems : ArrayX;
		public var menuDataItems : ArrayX;
		public var heirarchyDepth : Number = 0;
		public var data_xml : XMLDocument;
		public static var SELECTED_SLIDE_EVT : AEvent = AEvent.getNext("SELECTED_SLIDE");
	
		protected var rate : Number;
	
		protected var _oy : Number;
	
		protected var playList : ArrayX;
	
		protected var playlistViewModel : CompoundLine1D;
	
		protected var centerX : Number;
	
		protected var lastMousePos : String;
	
		protected var _xadj : Number = 0;
		protected var speed : Number = 0;
		public var curSelectedClip : Object;
		//////////////////CONSTRUCTOR///////////////////////////////
		public function CarouselMenu() {
			super(null, "CarouselMenu", false);
			trace(" CarouselMenu");
			menuUIItems =  new ArrayX();
			menuDataItems =  new ArrayX();
			//////////////Activate the statemachine ///////////
			init();
		}
		public function getPlaylist() : RandomizedPlayList{
			var pl : RandomizedPlayList = new RandomizedPlayList();
			pl.appendArray(["A"," B","C","D", "E"]);
			trace("playlistA " + pl.toString(true));
			return pl;		
		}
		public function parsePlayList(playList : RandomizedPlayList) : void{
		trace(" playList parse:" + playList.toString(true));
			playlistViewModel = new CompoundLine1D("PlayList", 1, 0, 0,null);
			var c : Number = 0;
			var curX : Number = 0;
			var itemWidth : Number = 90;
			while(playList.hasNext()){
				var page : Object = playList.getNext();
				//trace("Adding Cell " + page);
				var line : Line1D = new Line1D("PlayListItem", 1, playlistViewModel.B,itemWidth,null);
				line.data = page;
				playlistViewModel.addChild(line);
				if(c == 200){
					trace(" parsePlayList breaking loop 200 items!");
					break;
				}			
			}
		//	trace("HIGHLIGHT parsed PlayListViewModel"+ playlistViewModel);
		}
		public function setXY(x : Number, y : Number) : void{
			x = x;
			y = y;
		}
		public function setWidthHeight(aW : Number, h : Number) : void{
			trace("HIGHLIGHTP KTClientMediaPlayer.setWidthHeight w " + aW + " h " + h);
			playlistvisiblewindow_mc.width = aW;
			playlistvisiblewindow_mc.height = h;
		}
		public function setX(aX : Number) : void {
			setXY(aX, y);
		}
		public function setY(aY : Number) : void {
			setXY(x, aY);
		}
		public function setWidth(aWidth : Number) : void {
			trace("MEDIA PLAYER.setWidth " + aWidth);
			setWidthHeight(aWidth, null);
		}
		public function setHeight(aHeight : Number) : void {
			trace("MEDIA PLAYER.setHeight " + aHeight);
			setWidthHeight(null, aHeight);
		}
		///////////////////////////// EVENTS ///////////////////////////////////////////
		public function hide() : void{
			Q_TRAN(s2_hiddenCarousel);
		}
		public function show() : void{
			Q_TRAN(s2_animatingCarousel);
		}
		public function onLoad() : void{
			super.onLoad();
			trace("onLoad");
			centerX = this.width/2;
			_owidth = this.width;
			//playlistvisiblewindow_mc.visible =true;
			Q_dispatch(ASSETS_LOADED_EVT);
	//		
		}
			/********************************
		* This configures the rotation
		* rate based on the mouses position
		* there are 3 basic zones,
		* left side, right side and center.
		* center is a slow/zero zone, setting to zero when crossing center.
		*/
		public function onMouseMove() : void {
			public var b2:Bounds2 = new Bounds2(playlistvisiblewindow_mc.getBounds());
			//trace("mouseX " + mouseX + " " +b2);
			if(b2.contains(playlistvisiblewindow_mc.mouseX,playlistvisiblewindow_mc.mouseY)){
				if(myCurState == s2_pauseCarousel){
					Q_TRAN(s2_animatingCarousel);
				}
				
				if (playlistvisiblewindow_mc.mouseX<(50)) {
						lastMousePos = "LEFT_SIDE";
					
						rate = -5;//(this.mouseX-(centerX-100 + _xadj));//_owidth;
						trace("GO -- " + rate);
				} else if ((b2.xMax-50) <playlistvisiblewindow_mc.mouseX) {
						lastMousePos = "RIGHT_SIDE";
						rate = 5;//(this.mouseX-(centerX+100 + _xadj));///_owidth;
						trace("--GO " + rate);
				} else {
					trace("SPEED C "+speed);
					if (rate != 0) {
						if (lastMousePos == "LEFT_SIDE" && mouseX>centerX) {
							rate = 0;
						} else if (lastMousePos == "RIGHT_SIDE" && mouseX<centerX) {
							rate = 0;
						}
					}
				}
				var maxSpeed:Number = 3;
				//rate = Math.max((-1* maxSpeed),Math.min(rate,maxSpeed));
				trace(" throttled rate "  + rate);
			}else{
				rate = 0;
				if(myCurState == s2_animatingCarousel){
					Q_TRAN(s2_pauseCarousel);
				}
			}
		};
		//////////////////////// LEVEL 0 STATES////////////////////////////
	/*.................................................................*/
		function s1_creatingView(e : AEvent) : Function
		{
			this.onFunctionEnter ("s1_creatingView-", e, []);
			switch (e)
			{
				case ENTRY_EVT :
				{
					trace("HIGHLIGHTL s1_creatingView ");
					var pl : RandomizedPlayList = getPlaylist();
					parsePlayList(pl);
					var cx : Number = 0;
					var ini1 : Object = new Object();
					ini1.x = cx;			
					var USEBOOKENDS:Boolean = true;
					if(USEBOOKENDS){
						//////////// PLACE START BOOKEND /////////////////
						var menuStart : MovieClip = attachMovie("PlaylistStart", "photoStart", getNextHighestDepth(),ini1);
						menuStart.width =40;
						menuUIItems.push(menuStart);
	
						cx+= 40;
					}
					////////// PLACE BOOKS /////////////////
					for (var i : Number = 0; i < playlistViewModel.children.length; i++) {
						var l : Line1D = playlistViewModel.children[i];
						trace("line " + l);
						var ini : Object = new Object();
						ini.x = l.A + cx;
						cx += l.B.position;
						var menuItem : FramedMediaPlayer = FramedMediaPlayer(attachMovie("PlaylistPhotoButton", "photo"+i, getNextHighestDepth(),ini));
						trace("creating View " + util.Trace.me(l.data, "DATA", true));
						menuItem.contentURL = l.data.smallIcon;//"users/icon1.PNG";
						menuItem.label = l.data.shortName;
						menuItem.data = l.data;
						Object(menuItem).menu = this;
						menuItem.addEventListener("CLICK",this, this.createCallback(SELECTED_SLIDE_EVT));
						menuItem.addEventListener("CLICK", this, this.onChildClicked);
						menuItem.mode = Table3DRotaryCarouselMenuItem.LINEAR_CAROUSEL_MODE;
						decorateClip(menuItem);
						menuUIItems.push(menuItem);
					}
					if(USEBOOKENDS){
						////////// PLACE END BOOKEND /////////////////
						var ini2 : Object = new Object();
						ini2.x = cx;
	
						var menuEnd : MovieClip = attachMovie("PlaylistEnd", "photoEnd", getNextHighestDepth(),ini2);
						menuEnd.width = 40;
						decorateClip(menuEnd);
						menuUIItems.push(menuEnd);
					}
					return null;
				}
				case EXIT_EVT :
				{
					return null;
				}
				case INIT_EVT :
				{
					Q_TRAN(s2_animatingCarousel);
					return null;
				}
			}
			return this.s0_viewAssetsLoaded;
		}
	
		////////////////////////////LEVEL 2 States ///////////////////////
		/*.................................................................*/
		function s2_animatingCarousel(e : AEvent) : Function
		{
			this.onFunctionEnter ("s2_animatingCarousel-", e, []);
			switch (e)
			{
				case ENTRY_EVT :
				{
					startPulse(1000/24);
					return null;
				}
				case EXIT_EVT :
				{
					stopPulse();
					return null;
				}
				case INIT_EVT :
				{
					return null;
				}
				case SELECTED_SLIDE_EVT:
				{
					trace("000000000000000000000000000000000000000000000000000000");
					trace("000000000000000000000000000000000000000000000000000000");
					trace("00000000000000000000SELECTED_SLIDE_EVT0000000000000000000000000000000000");
					trace("000000000000000000000SELECTED_SLIDE_EVT000000000000000000000000000000000");
					trace("000000000000000000000000000" + util.Trace.me( parent.main_window)+ "000000000000000000000000000");
					trace("000000000000000000000000000000000000000000000000000000");
					parent.main_window.mxP.setContentTo(curSelectedClip.data.contentURL);
					parent.main_window.setEnabled(false);
					dispatchEvent({type:SELECTED_SLIDE_EVT, data:curSelectedClip.data});
					break;
				}
				case PULSE_EVT:
				{
				//	var xpos : Number = Math.min(Math.max(0, (this.mouseX-this.playlistvisiblewindow_mc.x)/this.playlistvisiblewindow_mc.width), 100);
					///trace("***********************************");
				//trace("*************rate " + rate + " **********************");
				//	var acceleration = Math.cos(Math.PI*xpos)*rate*-1;
					var acceleration : Number = rate;
		//			var cx : Number = (playlistvisiblewindow_mc.width < playlistViewModel.length)? Math.round(menuUIItems.getFirstElement().x-acceleration):0;
					var cx : Number = Math.round(menuUIItems.getFirstElement().x-acceleration);
				
					//trace(" this "+this+" parent "+this.enterBook+" move? "+(this.y<(this._oy+playlistvisiblewindow_mc.getBounds().yMax+20)));
					/*	if ((this.enterBook == true) && (this.y<(this._oy+playlistvisiblewindow_mc.getBounds().yMax-20))) {
						this.y += 4;
						this.parent.pagelist.y -= 4;
					} else if ((this.enterBook == false) && this.y>this._oy) {
						this.y -= 4;
						this.parent.pagelist.y += 4;
					}*/
					//if (this.enterBook == false) {
					for (var i : Number = 0; i<menuUIItems.length; i++) {
						////////////// MOVE CLIPS (start from left to right)/////////////////////
						var clip : MovieClip = MovieClip(menuUIItems[i]);
						//trace("moving clip " + i + " " + clip + "cx " + cx);
						clip.x = (clip.isToggled)?clip.x:cx;
						if (clip.zoomme == "UP" && clip.scaleY<130) {
						//	trace("zoooming up");
							clip.scaleX = clip.scaleY=(clip.scaleY+2);
						} else if (clip.zoomme == "DOWN" && clip.scaleY>100) {
						//	trace("zoooming down");
							clip.scaleX = clip.scaleY=(clip.scaleY-2);
						}
						cx = cx+clip.width*(clip.scaleX/100)+clippadding;
					}
					for (var i : Number = 0; i<menuUIItems.length; i++) {
						var clip : MovieClip = MovieClip(menuUIItems[i]);
						////////////  RECYCLE CLIPS ////////////////////////////////////
						if (acceleration>=0) {
							var xMax:Number = clip.x+clip.width;
							if (xMax<playlistvisiblewindow_mc.x) {
								trace("******************RECYCLING FROM LEFT***********"+clip);
								var lastClip : MovieClip = MovieClip(menuUIItems.getLastElement());
								//use the orignal widht not the current width
								clip.x = lastClip.x+lastClip.width+clippadding;
					//			clip.label_txt.text = recycles++;
								clip.alpha = 100;
								menuUIItems.shiftTowardsEnd();
							} else if (clip.x<playlistvisiblewindow_mc.x && playlistvisiblewindow_mc.x<xMax) {
								clip.alpha = (1-(playlistvisiblewindow_mc.x-clip.x)/clip.width)*100;
							} else if (clip.x<(playlistvisiblewindow_mc.x+playlistvisiblewindow_mc.width) && (playlistvisiblewindow_mc.x+playlistvisiblewindow_mc.width)<xMax) {
								var a = (((playlistvisiblewindow_mc.x+playlistvisiblewindow_mc.width)-clip.x)/clip.width)*100;
								clip.alpha = a;
								//
							}
						} else if (acceleration<0) {
							var lastClip : MovieClip = MovieClip(menuUIItems.getLastElement());
							var xMax = lastClip.x + lastClip.width;
							if (playlistvisiblewindow_mc.x+playlistvisiblewindow_mc.width<lastClip.x) {
								trace("******************RECYCLING FROM RIGHT***********"+lastClip);
								var firstClip : MovieClip = MovieClip(menuUIItems.getFirstElement());
								//use the orignal widht not the current width
								lastClip.x = firstClip.x-lastClip.width-clippadding;
				//					clip.label_txt.text = recycles++;
								trace("BEFORE "+menuUIItems.join("\r"));
								menuUIItems.shiftTowardsStart();
								trace("AFTER "+menuUIItems.join("\r"));
							} else if (clip.x<playlistvisiblewindow_mc.x && playlistvisiblewindow_mc.x<xMax) {
								var a = (1-(playlistvisiblewindow_mc.x-clip.x)/clip.width)*100;
								//trace("BIRTH" + a);
								clip.alpha = a;
							} else if (clip.x<(playlistvisiblewindow_mc.x+playlistvisiblewindow_mc.width) && (playlistvisiblewindow_mc.x+playlistvisiblewindow_mc.width)<xMax) {
							//	trace("BIRTH");
								var a = (((playlistvisiblewindow_mc.x+playlistvisiblewindow_mc.width)-clip.x)/clip.width)*100;
								clip.alpha = a;
								//
							}
						}
							//}
					}
					return null;
				}
			}
			return this.s1_viewCreated;
		}
		function s2_pauseCarousel(e : AEvent) : Function
		{
			this.onFunctionEnter ("s2_pauseCarousel-", e, []);
			switch (e)
			{
				case ENTRY_EVT :
				{
					return null;
				}
				case EXIT_EVT :
				{
					return null;
				}
	
			}
			return this.s1_viewCreated;
		}
		function s2_hiddenCarousel(e : AEvent) : Function
		{
			this.onFunctionEnter ("s2_hiddenCarousel-", e, []);
			switch (e)
			{
				case ENTRY_EVT :
				{
					this.visible = false;
					return null;
				}
				case EXIT_EVT :
				{
					this.visible = true;
					return null;
				}
	
			}
			return this.s1_viewCreated;
		}
	/////////////////////////////////////////////////////////////////////////////
	//  Model Related Functions
	////////////////////////////////////////////////////////////////////////////
		public function setDataProvider(_ary : Array) : void{
		
		}
		public function onChildClicked() : void {
			trace("onChildClicked");
		}
	
		function decorateClip(_mc : MovieClip) : void {
		//_mc.cacheAsBitmap = true;
			_mc.onRollOut = function() {
				trace("ROLLOVER");
				Object(this).zoomme = "DOWN";
		};
			_mc.onRollOver = function() {
				trace("ROLLOUT");
				Object(this).zoomme = "UP";
			//this.scaleX =103;
		};
			_mc.onRelease = function() {
				trace("*** CLICK *******"+MovieClip(this).parent+" 2 "+MovieClip(this).parent);
				MovieClip(this).parent.enterBook = !MovieClip(this).parent.enterBook;
		};
			_mc.zoomCount = 0;
	}
	
		
	}
}