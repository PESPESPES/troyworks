package com.troyworks.controls.tmediaplayer.ui {
	import flash.display.DisplayObject;	
	
	import com.troyworks.controls.tmediaplayer.MixinPlayer;	
	import com.troyworks.core.tweeny.Elastic;	
	import com.troyworks.core.tweeny.Tny; 
	import com.troyworks.framework.ui.BaseComponent;
	import com.troyworks.framework.loader.MCLoader;
	import com.troyworks.framework.ui.IHaveChildrenComponents;
	import com.troyworks.util.DesignByContract;
	import com.troyworks.controls.tdraggable.DragProxy;
	import com.troyworks.ui.Bounds2;
	/**
	 * This player is a generic player for flash content that typically 
	 *  a cover (eg. for a loading animation
	 *  a background (e.g. a flat color)
	 *  
	 *  it can accept, flv,swf, images or attachMovies from the library
	 *  it also scales and centers appropriately.
	 *  
	 * @author Troy Gardner
	 */
	import flash.ui.Mouse;
	import flash.display.MovieClip;
	import flash.display.Stage;
	public class MultiMediaWindow extends BaseComponent {
		var base_mc : DisplayObject;
		public static var _className : String = "com.troyworks.mediaplayer.ui.MultiMediaWindow";
		//These exist in a heirarchy of
		// MyArt ( a clip you create and pass in)
		//  |_Mask _vectormask_mc (a mask over the content)
		//  |_Shell
		//      |_frame_mc (a picture frame concept for loading etc.
		//      |_cover_mc (a cover for loading etc.
		//      |_overlay_mc (place to put textfields) (NOT IMPLMENTED)
		//      |_bitmap_mc   (bitmap effects_of the main content
		//      |_ph_mc (PlaceHolder holds the main content, SWF, JPG etc)
		//      |_video (an optional container for FLV player)
		//      |_background_mc
		var x : Number = 0;
		var y : Number = 0;
		var width : Number = 0;
		var height : Number = 0;
		var autoStart : Boolean = true;
		var autoRewind : Boolean = true;
		var activateMXP : Boolean = false;
		
		var hasOnLoad : Boolean = false;
		/* A controller for loaded swfs */
		var mxP : MixinPlayer;
		/////////////////////////////////////
		protected var contentPATH : Object = null;
		protected var maskPATH : Object = null;
	
		protected var framePATH : Object;
	
		protected var coverPATH : Object;
	
		protected var loadingProgressPATH : Object;
	
		protected var backgroundPATH : Object;
	
		protected var contentFilters : Array;
	
		protected var mcL : MCLoader;
		var isDraggable:Boolean = false;
		public static var Event_RECIEVED_CONTENT:String = "Event_RECIEVED_CONTENT";
		/******************************************
		 * Constructor
		 */
		public function MultiMediaWindow(placeHolderArea_mc : MovieClip) {
			super();
			trace("cccccccccccccccccccccccccccccccccccccccccccccc");
			trace("cccccccccccccccccccccccccccccccccccccccccccccc");
			trace("ccccccccccccccccccccccc MultiMediaWindow ccccccccccccccccccccccc");
			trace("ccccccccccccccccccc placeHolderArea_m:  " + placeHolderArea_mc + " cccccccccccccccccccccccccccc");
			trace("ccccccccccccccccccc this:  " + this + " ccccccccccccccccccccccccccc");
			trace("cccccccccccccccccccccccccccccccccccccccccccccc");
			base_mc = (placeHolderArea_mc == null)?this.view:placeHolderArea_mc;
			if(maskPATH != null){
				setMaskTo(maskPATH);
			}
			if(framePATH != null){
				setFrameTo(framePATH);
			}
			if(coverPATH != null){
				setCoverTo(coverPATH);
			}
			
			if(contentPATH != null){
				setContentTo(contentPATH);
			}
			if(backgroundPATH != null){
				setBackgroundTo(backgroundPATH);
			}
			
		}
		public function onPressHandler() :void{
			trace("on dragProxyRequest");
	
		
		
		    DragProxy.getInstance().setDragSource(this);
			onMouseUp = releaseDragProxy;
		}
		function releaseDragProxy():void{
			DragProxy.getInstance().releaseDragSource(this);
			delete(onMouseUp);
		}
		public static function createLoadingShell(_mc : MovieClip) : MovieClip{
	
			var shell_mc : MovieClip = _mc.createEmptyMovieClip("shell_mc", 2);//_mc.getNextHighestDepth());
			_mc.createEmptyMovieClip("mask_mc",3);// _mc.getNextHighestDepth());
			//shell_mc.visible = false;
			///////// Create the placeholder and the cover for it.
			var background_mc : MovieClip = shell_mc.createEmptyMovieClip("background_mc", 2);
			var ph_mc : MovieClip = shell_mc.createEmptyMovieClip("ph_mc", 3);
			
			shell_mc.createEmptyMovieClip("bitmap_mc", 4);
			shell_mc.createEmptyMovieClip("cover_mc", 5);
			shell_mc.createEmptyMovieClip("loadingProgress_mc", 6);
			shell_mc.createEmptyMovieClip("frame_mc", 7);
			return ph_mc;
		}
		public static function setClipContentTo(base_mc : Object, target_mc : MovieClip, o : Object, alpha : Number, loadingProgress_mc : MovieClip) : MCLoader{
			trace("setClipContentTo : " + o);
			DesignByContract.REQUIRE(target_mc != null,"seClipContentTo target cannot be null");
			///////////////// Validate data//////////////////
			alpha = (alpha == null)?100:alpha;
			var bounds : Object = new Object();
			 if(base_mc is MultiMediaWindow){
				trace("----using MultiMediaWindow");
				var mmW : MultiMediaWindow = MultiMediaWindow(base_mc);
				bounds.x = 0;
				bounds.y = 0;
				bounds.width = mmW.base_mc._oawidth;//width-2;
				bounds.height = mmW.base_mc._oaheight;//mxP.height-2;
			}else if(base_mc is MovieClip){
				trace("----using MoveClip");
				bounds.x = 0;
				bounds.y = 0;
				bounds.width = base_mc._oawidth;//base_mc.width;
				bounds.height = base_mc._oaheight;//
			}
	//		trace(util.Trace.me(bounds, "SETTING CLIP CONTENT ", true));
	//		trace(util.Trace.me(base_mc, "LOOKING FOR LOADING ", true));
			//////////Process the request/////////////
			
			if(o== null){
				trace("HIGHLIGHTB  removing");
				//rmove the clip
				target_mc.graphics.clear();
				target_mc.removeMovieClip();
				target_mc.unloadMovie();
			}else if(typeof(o) == "string"){
				var s : String = String(o);
				var mcL : MCLoader = new MCLoader(s,target_mc);
	
				if(mcL.isJPEG || mcL.isPNG || mcL.isGIF){
					//load an IMAGE
					trace("HIGHLIGHTB  loading an Image");
					mcL.smooth = true;
					mcL.loadingProgress_mc = (loadingProgress_mc.LoadingProgress_mc== null)?loadingProgress_mc:loadingProgress_mc.LoadingProgress_mc;
					mcL.startLoading();
				}else if(mcL.isSWF){
					//load a SWF
					trace("HIGHLIGHTB loading a SWF");
					mcL.useContainer = true;
					mcL.loadingProgress_mc = (loadingProgress_mc.LoadingProgress_mc== null)?loadingProgress_mc:loadingProgress_mc.LoadingProgress_mc;
					mcL.startLoading();
				}else{
					///attach a movie
					trace("HIGHLIGHTB attempting to attach Movie: " + String(o) + " target " + target_mc);
					target_mc.attachMovie(String(o),String(o)+"_mc",3);
					mcL = null;
				}
				return mcL;
			}else if(typeof(o) == "number"){
				trace("---------CREATING A VECTOR BACKGOUND --------w: " + bounds.width + " h: " + bounds.height + " " + Number(o)+ " alpha "  + alpha);
				///create a vector colored  background
				target_mc.graphics.moveTo(0, 0);
				target_mc.graphics.beginFill(Number(o), alpha);
				target_mc.graphics.lineTo(bounds.width, 0);
				target_mc.graphics.lineTo(bounds.width, bounds.height);
				target_mc.graphics.lineTo(0, bounds.height);
				target_mc.graphics.endFill();
			}else{
				DesignByContract.REQUIRE(false, "MultiMediaWindow passed an invalid type" + o);
			}
			return null;
		}
		////////////////////////////////////////////////////////////////////////////////////////
		public function setMaskTo(o : Object) : void{
	
			maskPATH = (o == null)?0xFF0000:o;
			if(hasOnLoad){
				trace(view.name+".setMaskTo xxxxxxxxxxxxxxxxxxxxxxxxxx" + o);
				setClipContentTo(this, base_mc.mask_mc, maskPATH);
				//trace("attempting to set mask" + base_mc.shell_mc + " " + base_mc.mask_mc);
				base_mc.shell_mc.setMask(base_mc.mask_mc);
			}
				
		}
		public function setFrameTo(o : Object, alpha : Number = 1) : void{
			trace(view.name+".setFrameTo " + o + " alpha : " + alpha);
			framePATH = o;
			if(hasOnLoad){
				setClipContentTo(this, base_mc.shell_mc.frame_mc, framePATH, alpha);
			}
		}
		public function setLoadingProgressIndicatorTo(o : Object, alpha : Number) : void{
			trace(view.name+".setLoadingProgressIndicatorTo " + o + " alpha : " + alpha);
			loadingProgressPATH = o;
			if(hasOnLoad){
				setClipContentTo(this, base_mc.shell_mc.loadingProgress_mc, loadingProgressPATH, alpha);
			}
			
		}
		public function setCoverTo(o : Object, alpha : Number= 1) : void{
			trace(view.name+".setCoverTo " + o + " alpha : " + alpha);
			coverPATH = o;
			if(hasOnLoad){
				REQUIRE(base_mc.shell_mc.cover_mc != null, " setCoverTo base_mc.shell_mc.cover_mc cannot be null");
				setClipContentTo(this, base_mc.shell_mc.cover_mc, coverPATH, alpha, base_mc.shell_mc.loadingProgress_mc);
			}
		}
		public function setContentTo(o : Object, alpha : Number, filters : Array, isInteractive:Boolean) : void{
			trace(view.name+".setContentTo " + o+ " alpha : " + alpha + " filters " + filters +  " isInteractive " + isInteractive + " hasOnLoad: " + hasOnLoad);
			contentPATH = o;
			contentFilters = filters; 
			if(hasOnLoad){
			
				setCoverTo(0xffffff, 100);
				
				//unload whatever was in the spot before
	
				base_mc.shell_mc.createEmptyMovieClip("ph_mc", 3);
			//	base_mc.width = base_mc._owidth;
			//	base_mc.height = base_mc._oheight;
				//snapshotDimensions(base_mc);
				REQUIRE(base_mc.shell_mc.ph_mc != null, " setContentTo base_mc.shell_mc.ph_mc cannot be null");
		
			//	base_mc.shell_mc.ph_mc.visible = false;
				trace(util.Trace.me(base_mc, "MultiMediaWindow check", true));
				 mcL = setClipContentTo(this,base_mc.shell_mc.ph_mc, contentPATH, alpha, base_mc.shell_mc.loadingProgress_mc.LoadingProgressIndicator_mc);
				if(mcL != null){
					if(mcL.isSWF && (isInteractive == null || isInteractive == false) && (contentPATH.indexOf("KTLoader.swf")==-1)){
						mxP = new MixinPlayer(mcL.actTarget);
						mxP.autoStart = autoStart;
						mxP.autoRewind = autoRewind;
						if(activateMXP){
							mxP.init();
						}
					}else{
						mxP = null;
					}
		
					mcL.addEventListener(MCLoader.EVT_DATA_LOADED, this, this.onRecievedContentData);	
					mcL.addEventListener(MCLoader.EVT_FINISHED_LOADING, this, this.onSetContent);
				}else{
					onRecievedContentData();
					onSetContent();
				}
			}
		}
		public function setBackgroundTo(o : Object, alpha : Number) : void{
			trace(this.view.name + " setBackgroundTo " + o+ " alpha : " + alpha);
			backgroundPATH = o;
			if(hasOnLoad){
				REQUIRE(base_mc.shell_mc.background_mc != null, " setContentTo base_mc.shell_mc.background_mc cannot be null");
				setClipContentTo(this,base_mc.shell_mc.background_mc, o, alpha, base_mc.shell_mc.loadingProgress_mc);
			}
		}
		public function onRecievedContentData() : void{
			trace("#######################################################");
			trace("####################### onRecievedContentData ################################");
			trace("################## content xscale " +base_mc.shell_mc.ph_mc.scaleX + " " + base_mc.shell_mc.ph_mc.scaleY + " ################");
			trace("############### content actual " + 	base_mc.shell_mc.ph_mc.width +", "+ 	base_mc.shell_mc.ph_mc.height +  " ################ orig display " + base_mc._owidth + " " + base_mc._oheight  + " ########################");
			trace("################# content viewport? " + mcL.actTarget.viewport_mc.width + " "  + mcL.actTarget.viewport_mc.height+ " ######################################");
			
			if(mcL.actTarget.viewport_mc == null){
				trace("no view port ");
				snapshotDimensions(base_mc.shell_mc.ph_mc);
				trace(util.Trace.me(base_mc.shell_mc.ph_mc, "base_mc.shell_mc.ph_m"));
				scaleTo(null, base_mc.shell_mc.ph_mc, base_mc._oawidth, base_mc._oaheight);
			}else{
				trace("using viewport");
	//			snapshotDimensions(base_mc.shell_mc.ph_mc);
	//			scaleTo(null, base_mc.shell_mc.ph_mc, base_mc._oawidth, base_mc._oaheight);
				snapshotDimensions(mcL.actTarget );
				scaleTo(null, mcL.actTarget , base_mc._oawidth, base_mc._oaheight, mcL.actTarget.viewport_mc.width, mcL.actTarget.viewport_mc.height);
	
			//	var b:Object = new Object();
			//	b.width = base_mc._owidth;
			//	b.height = base_mc._oheight;
			//	scaleTo2( base_mc.shell_mc.ph_mc, b);
			}
			trace("applying filters " + contentFilters);
			if(contentFilters !=null){
	
				base_mc.shell_mc.ph_mc.filters = contentFilters;
			}
			base_mc.shell_mc.ph_mc.visible = true;
	//		base_mc.shell_mc.ph_mc.width = width;//base_mc._owidth;
	//		base_mc.shell_mc.ph_mc.height =height;// base_mc._oheight;
			trace("ERROR dispatchnig Event_RECIEVED_CONTENT");
			var evtd:Event = new Event(Event_RECIEVED_CONTENT, this);
			dispatchEvent(evtd);
		}
		public function getContentBounds(context:MovieClip):Bounds2{
			if(context == null){
				context = base_mc.shell_mc;
			}
			var b2:Bounds2 = new Bounds2(base_mc.shell_mc.ph_mc.getBounds(context));
			return b2;
		}
		public function setContentFilters(filters:Array):void{
			contentFilters = filters;
			base_mc.shell_mc.ph_mc.filters = contentFilters;
		}
		public function getContentMC():MovieClip{
			if(base_mc.shell_mc.ph_mc != null){
			return base_mc.shell_mc.ph_mc;
			}else{
			 return	base_mc.shell_mc;
			}
		}
		public function getFrameMC():MovieClip{
			return base_mc.shell_mc.frame_mc;
		}
		public function setX(x : Number) : void{
			x = x;
		}
		public function setY(y : Number) : void{
			y = y;
		}
	
		public function traceS():void{
			trace(" base_mc " + base_mc.scaleX + " " + base_mc.scaleY + " " + base_mc.width + " " + base_mc.height);
			trace("   shell_mc " + base_mc.shell_mc.scaleX + " " + base_mc.shell_mc.scaleY + " " + base_mc.shell_mc.width + " " + base_mc.shell_mc.height);
			trace("     base_mc.shell_mc.ph_mc, " + base_mc.shell_mc.ph_mc.scaleX + " " + base_mc.shell_mc.ph_mc.scaleY + " " + base_mc.shell_mc.ph_mc.width + " " + base_mc.shell_mc.ph_mc.height);
		}
		public function setWidthHeight(w : Number, h : Number) : void{
			this.width = w;
			this.height = h;
			trace("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
			traceS();
		//	trace("XXXXXXXXXXX Mixin SetContentWidth and Height" + w + " " + h + " curr " + this.width + " " + this.height + " " + util.Trace.me(this.base_mc));
			//scaleTo( base_mc,  base_mc.shell_mc.ph_mc);
			var xadj : Number = w/base_mc._owidth;
			var yadj : Number = h/base_mc._oheight;
		//	 trace("---------------- External/Stage Perspective----------");
			trace("xadj " + xadj + " = " + w  + "/ " +base_mc._owidth);
			trace("yadj " + yadj + " = " + h  + "/ " +base_mc._oheight); 
		//	 trace("---------------- Movie Perspective----------");
			var desiredWidth : Number = base_mc._oawidth *xadj ;
			var desiredHeight : Number = base_mc._oaheight*yadj;
			 
			trace("desiredWidth " + desiredWidth + " = " + xadj  + "/ " +base_mc._oawidth);
			trace("desiredHeight " + desiredHeight + " = " + yadj  + "/ " +base_mc._oaheight);
			//DEBUG base_mc.shell_mc.ph_mc.alpha = 30; 
			trace("ph actuals " + mcL.actTarget._oawidth + " "+mcL.actTarget._oaheight); 
	
			//-------------scale keeping the aspect ratio, then center the content-------------------
			//scaleTo(null, base_mc.shell_mc.ph_mc, desiredWidth,desiredHeight, mcL.actTarget.viewport_mc.width, mcL.actTarget.viewport_mc.height );
			if(mcL.actTarget.viewport_mc == null){
				trace("ERROR no view port ");
			//	snapshotDimensions(base_mc.shell_mc.ph_mc);
				trace(util.Trace.me(base_mc.shell_mc.ph_mc, "base_mc.shell_mc.ph_m"));
				scaleTo(null, base_mc.shell_mc.ph_mc,  desiredWidth,desiredHeight);
			}else{
				trace("HIGHLIGHTG using viewport");
	//			snapshotDimensions(base_mc.shell_mc.ph_mc);
	//			scaleTo(null, base_mc.shell_mc.ph_mc, base_mc._oawidth, base_mc._oaheight);
			//	snapshotDimensions(mcL.actTarget );
			var dw:Number = desiredWidth; /// mcL.actTarget.vp_owscale;
			var dh:Number = desiredHeight;// / mcL.actTarget.vp_ohscale;
		//	mcL.actTarget.width = dw;
		//	mcL.actTarget.height = dh;
				scaleTo(null, mcL.actTarget ,  dw,dh, mcL.actTarget.viewport_mc.width, mcL.actTarget.viewport_mc.height);
	traceS();
			//	var b:Object = new Object();
			//	b.width = base_mc._owidth;
			//	b.height = base_mc._oheight;
			//	scaleTo2( base_mc.shell_mc.ph_mc, b);
			}	
			//------------ fill these to whatever the dimensions are -------------------------------------------
			base_mc.shell_mc.background_mc.width = desiredWidth;
			base_mc.shell_mc.background_mc.height = desiredHeight;
			base_mc.shell_mc.cover_mc.width = desiredWidth;
			base_mc.shell_mc.cover_mc.height = desiredHeight;
			base_mc.shell_mc.loadingProgress_mc.width = desiredWidth;
			base_mc.shell_mc.loadingProgress_mc.height = desiredHeight;
			base_mc.shell_mc.frame_mc.width = desiredWidth;
			base_mc.shell_mc.frame_mc.height =  desiredHeight;	
		}
		public function onSetContent() : void{
			trace("#######################################################");
			trace("#######################onSetContent################################");
			trace("############### " + 	base_mc.shell_mc.ph_mc.width +", "+ 	base_mc.shell_mc.ph_mc.height +  " ################ orig " + base_mc._owidth + " " + base_mc._oheight  + " ########################");
			trace("#######################################################");
			var a : Tny = new Tny(base_mc.shell_mc.cover_mc);
			a.ease = Elastic.easeInOut;
			a.alpha = 1;
			a.duration = 1.5; 
			//scaleTo(null, base_mc.shell_mc.ph_mc, base_mc._owidth, base_mc._oheight); 
	//		base_mc.shell_mc.ph_mc.width = width;//base_mc._owidth;
	//		base_mc.shell_mc.ph_mc.height =height;// base_mc._oheight;
		}
		/*.................................................................*/
		function s0_viewAssetsLoaded(e : CogEventntntnt) : Function
		{
			this.onFunctionEnter ("s0_viewAssetsLoaded-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				{
					trace("AAAAAAAAAAAAAAAAAAAAAAAAAAA "+ view.name +" 'MultiMediaWindow' s0_viewAssetsLoaded AAAAAAAAAAAAAAAAAAAAAAAAAAAA  \r " + util.Trace.me( owner));
				//	REQUIRE(owner != null, "MultiMediaWindow owner cannot be null");
					REQUIRE(base_mc != null, "MultiMediaWindow base_mc cannot be null");
					snapshotDimensions(base_mc);
					setWidthHeight(base_mc.width, base_mc.height);
			        ///create loading clips //////////
					createLoadingShell(base_mc);
					trace(util.Trace.me(this, "MultiMediaWindow check", false));
	
					hasOnLoad = true;
					///if these were set prior to onLoad/////////
					if(maskPATH != null){
						setMaskTo(maskPATH);
					}
					if(framePATH != null){
						setFrameTo(framePATH);
					}
					if(loadingProgressPATH != null){
						setLoadingProgressIndicatorTo(loadingProgressPATH);
					}
					if(contentPATH != null){
						setContentTo(contentPATH, null, contentFilters);
					}
					if(backgroundPATH != null){
						setBackgroundTo(backgroundPATH);
					}
					if(isDraggable){
						onPress = onPressHandler;
					}
					//owner.onChildClipLoad(this);
					return null;
				}
				case SIG_EXIT :
				{
					tran(s0_viewAssetsUnLoaded);
					return null;
				}
				case SIG_INIT :
				{
					tran(s1_creatingView);
					return null;
				}
			}
			return s_root;
		}
	
	}
}