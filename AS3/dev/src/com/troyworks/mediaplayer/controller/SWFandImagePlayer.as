package com.troyworks.mediaplayer.controller { 
	 //import util.SWFUtilBasic;
	//import util.BasicLoader;
	import com.troyworks.hsmf.AEvent;
	import com.troyworks.hsmf.Signal;
	import com.troyworks.hsmf.Hsmf;
	import flash.display. *;
	//import com.troyworks.spring.Factory;
	//import com.troyworks.framework.IApplication;
	//import util.TEventDispatcher.troyworks.framework.ui.BaseComponent ;
	//import com.kidthing. *;
	//import com.troyworks.util.director.DirectorUtils;
	//http://livedocs.macromedia.com/flex/1/asdocs/mx/controls/MediaDisplay.html
	import flash.utils.getTimer;
	import flash.display.MovieClip;
	public class SWFandImagePlayer extends com.troyworks.mediaplayer.ASynchronizedMediaPlayer
	{
		public var mask_mc : MovieClip;
		public var shell_mc : MovieClip;
		public var ph_mc : MovieClip;
		public var bp_mc : MovieClip;
		public var autoPlay : Boolean = false;
		public var autoPreload : Boolean = false;
		public var m_width : Number = null;
		public var m_height : Number = null;
		//information about the media transition.
		public var mediaTran : Object = null;
		public var Asize : Number = 0;
		public var Ax : Number = 0;
		public var Ay : Number = 0;
		public var Bsize : Number = 0;
		public var Bx : Number = 0;
		public var By : Number = 0;
		public var xstep : Number = 0;
		public var ystep : Number = 0;
		public var xscalestep : Number = 0;
		public var yscalestep : Number = 0;
		//original values
		public var _ox : Number = 0;
		public var _ow : Number = 0;
		public var _oh : Number = 0;
		public var _oy : Number = 0;
		public var _oxscale : Number = 0;
		public var _oyscale : Number = 0;
		//calc values
		public var _cx : Number = 0;
		public var _cy : Number = 0;
		//the path to the media Data
		public var mediaPath : String = null;
		public var data : Object = null;
		public var tracesOn : Boolean = false;
		public var loadStartTime : Number = 0;
		public var loadEndTime : Number = 0;
		public var isLoaded : Boolean = false;
		public var smooth : Boolean = false;
		public var calculatedBandwidth:Number = - 1;
		//	public var hsmName:String = "MPB";
		public var contentIsLoaded : Boolean = false;
		protected var pauseExitTime : Number = -1;
		public function SWFandImagePlayer ()
		{
			super (awaitingMovieAttachOnLoad);
			trace ("AAAAAAAAAAAAAAAA SWFandImagePlayer " + this.hsmID);
			this.hsmName = "SWFIP" + this.hsmID + "-empty";
			this.hAlign = false;
		}
		public function onLoad () : void {
			trace ("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
			trace ("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
			trace ("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
			trace ("aaaaaaaaaaaaaaaaSWFImagePlayer.onLoad mediaPath: " + this.mediaPath + " aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
			trace ("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
			trace ("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
			trace ("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
			super.onLoad ();
			//trace ("SWFImagePlayer.onLoadB1 h " + this.height + " " + this.width);
			this.init ();
			//	trace ("SWFImagePlayer.onLoadB2 h " + this.height + " " + this.width);
			this.shell_mc = this.createEmptyMovieClip ("shell_mc", this.getNextHighestDepth ());
			this.ph_mc = this.shell_mc.createEmptyMovieClip ("ph_mc", this.shell_mc.getNextHighestDepth ());
			this.bp_mc = this.shell_mc.createEmptyMovieClip ("bp_mc", this.shell_mc.getNextHighestDepth ());
			this.mask_mc = this.createEmptyMovieClip ("mask_mc", this.getNextHighestDepth ());
			trace ("SWFImagePlayer.onLoadB3 h " + this.height + " " + this.width);
			public var h : Number = this.m_height;
			public var w : Number = this.m_width;
			with (this.mask_mc )
			{
				graphics.moveTo (0, 0);
				graphics.beginFill (0xFF0000);
				graphics.lineTo (w, 0);
				graphics.lineTo (w, h);
				graphics.lineTo (0, h);
				graphics.endFill ();
			}
			//this.shell_mc.alpha = 30;
			this.shell_mc.setMask (this.mask_mc );
			//	trace ("BBBBBBBBBBBBBBBBBBBBB SWFandImagePlayer.onLoad" + this.shell_mc + " pl: " + this.shell_mc.ph_mc);
			//	trace ("BBBBBBBBBBBBBBBBBBBBB SWFandImagePlayer.onLoad" + this.mask_mc + " pl: " + this.shell_mc.ph_mc);
			//this._quality = "BEST";
			this.isLoaded = true;
			this.Q_TRAN (this.s1_active);
		}
		function setMedia (path : String) : void
		{
			trace ("bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb");
			trace ("bbbbbbbbbbbbbbbbbbbbbbbbbbbbbb SWFImagePlayer.setMedia bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb");
			trace ("bbbbbbbbbbbbbbbbbbbbbbbbbbbbbb " + this.mediaPath + "  bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb");
			trace ("bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb");
			if (this.mediaPath == path)
			{
				//same asset;
				
			} else
			{
				this.mediaPath = (path == null) ? this.mediaPath : path;
				if (this.mediaPath == null)
				{
					trace (this.hsmName + ".loadMedia '" + this.mediaPath + "' into " + this.shell_mc.ph_mc);
					this.shell_mc.ph_mc.unloadMovie ();
					this.hsmName = "SWFIP" + this.hsmID + "-emptyx";
					this.loadStartTime = - 1;
					this.loadEndTime = - 1;
					this.pauseExitTime = - 1;
					this.Q_TRAN (this.s1_active);
				} else if (this.mediaPath != null)
				{
					//trace ("Target Size " + this.A_height + " " + this.A_width + " " + this.shell_mc.width + " " + this.shell_mc.height);
					this.Q_TRAN (this.s1_preloadingMedia);
				}
			}
		}
		public function move (x : Number, y : Number) : void {
			this.x = x;
			this.y = y;
			//	this._cx = 0;
			//	this._cy = 0;
		}
		public function setSize (w : Number, h : Number) : void {
			//	this.width = w;
			//	this.height = h;
			
		}
		public function setupForPlay () : void {
			//+- data:object = [object Object]
			//+-- BhorzPos:string = Center
			//+-- BvertPos:string = Top
			//+-- Bsize:string = 80%
			//+-- AhorzPos:string = Center
			//+-- AvertPos:string = Bottom
			//+-- Asize:string = 80%
			//+-- height:number = 480
			//			+-- width:number = 640
			this.shell_mc.width = this._ow;
			this.shell_mc.height = this._oh;
			this.shell_mc.scaleX = this._oxscale;
			this.shell_mc.scaleY = this._oyscale;
			// Setup Transition
			if (true)
			{
				this.Asize = parseInt (this.mediaTran.Asize.substring (0, this.mediaTran.Asize.indexOf ("%")));
				this.shell_mc.scaleX = this.Asize;
				this.shell_mc.scaleY = this.Asize;
				this.Ax = this.alignH (this.mediaTran.AhorzPos, this.mask_mc, this.shell_mc, false);
				this.Ay = this.alignV (this.mediaTran.AvertPos, this.mask_mc, this.shell_mc, false);
				trace ("Asize " + this.Asize + " this.Ax " + this.Ax + " this.Ay " + this.Ay);
				this.shell_mc.width = Math.round (this.shell_mc.width);
				this.shell_mc.height = Math.round (this.shell_mc.height);
				this.shell_mc.x = this.Ax;
				this.shell_mc.y = this.Ay;
				this._cx = this.Ax;
				this._cy = this.Ay;
				this.Bsize = parseInt (this.mediaTran.Bsize.substring (0, this.mediaTran.Bsize.indexOf ("%")));
				this.Bx = this.alignH (this.mediaTran.BhorzPos, this.mask_mc, this.shell_mc, false);
				this.By = this.alignV (this.mediaTran.BvertPos, this.mask_mc, this.shell_mc, false);
				/////////////////////
				this._ox = this.Ax;
				this._oy = this.Ay;
			}
			//////////////////////////
			if (this.Ax == this.Bx)
			{
				//same position
			} else if (this.Ax > this.Bx)
			{
				//panning left
			} else if (this.Ax < this.Bx)
			{
				//panning right
			}
			if (this.Ay == this.By)
			{
				//same position
			} else if (this.Ay > this.By)
			{
				//panning left
			} else if (this.Ay < this.By)
			{
				//panning right
			}
			if (this.Asize == this.Bsize)
			{
				//same scale do nothing
			} else if (this.Asize > this.Bsize)
			{
				//zoom in
			} else if (this.Asize < this.Bsize)
			{
				//zoom out
			}
			public var framesToPlay = this.trk.length * 24;
			trace ("this.Bsize " + this.Bsize + " this.Bx " + this.Bx + " this.By " + this.By + " duration " + this.trk.length + " frames: " + framesToPlay + " Bscale " + Bscale);
			//figure out what to do during the transition (eventually need duration in this calculations);
			this.xstep = (this.Bx - this.Ax) / framesToPlay;
			this.ystep = (this.By - this.Ay) / framesToPlay;
			public var Bscale = (this.Bsize - this.Asize) / framesToPlay;
			trace ("zoom change " + (this.Bsize - this.Asize) + " " + Bscale);
			this.xscalestep = Bscale ;
			this.yscalestep = Bscale ;
			//var alphstep
		}
		//growing
		//shrinking
		//moving
		//
		/*.................................................................*/
		function awaitingMovieAttachOnLoad (e : AEvent) : Function
		{
			this.onFunctionEnter ("awaitingMovieAttachOnLoad-", e, []);
			switch (e)
			{
				case ENTRY_EVT :
				{
					//	this.swf.ui_preload.visible = false;
					//	this.skin_mc.visible = true;
					//	this.skin_mc.gotoAndPlay ("active");
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
				default :
				{
					//	trace("--------NOT HANDLED ");
					
				}
			}
			return s_top;
		}
		/*.................................................................*/
		function s1_active (e : AEvent) : Function
		{
			this.onFunctionEnter ("s1_active-", e, []);
			switch (e)
			{
				case ENTRY_EVT :
				{
					//	this.swf.ui_preload.visible = false;
					//	this.skin_mc.visible = true;
					//	this.skin_mc.gotoAndPlay ("active");
					return null;
				}
				case EXIT_EVT :
				{
					return null;
				}
				case INIT_EVT :
				{
					if (this.mediaPath != null)
					{
						this.Q_TRAN (this.s2_hasMediaPath);
					} else
					{
						this.Q_TRAN (this.s1_awaitingMediaPath);
					}
					return null;
				}
			}
			return s_top;
		}
		function s1_awaitingMediaPath (e : AEvent) : Function
		{
			this.onFunctionEnter ("s1_awaitingMediaPath-", e, []);
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
			return this.s1_active ;
		}
		function s2_hasMediaPath (e : AEvent) : Function
		{
			this.onFunctionEnter ("s2_hasMediaPath-", e, []);
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
				case INIT_EVT :
				{
					if (this.autoPreload)
					{
						trace (this + " media: " + this.mediaPath + " ******AUTO PRELOAD****** ");
						this.Q_TRAN (this.s1_preloadingMedia);
					}
					return null;
				}
			}
			return this.s1_active ;
		}
		function s1_preloadingMedia (e : AEvent) : Function
		{
			this.onFunctionEnter ("s1_preloadingMedia-", e, []);
			switch (e)
			{
				case ENTRY_EVT :
				{
					trace("==============================PRELOADING START =================================");
					//	this.shell_mc.setMask(this);
					this.shell_mc.visible = false;
					this.shell_mc.scaleX = 100;
					this.shell_mc.scaleY = 100;
					this.shell_mc.x = 0;
					this.shell_mc.y = 0;
					this._cx = 0;
					this._cy = 0;
					this.shell_mc.alpha = 100;
					this.contentIsLoaded = false;
					trace (this.hsmName + ".loadMedia '" + this.mediaPath + "' into " + this.shell_mc.ph_mc);
					this.log.debug ("SWFandImagePlayer.loadMedia '" + this.mediaPath + "' ");
					this.shell_mc.ph_mc.loadMovie (this.mediaPath );
					this.loadStartTime = getTimer ();
					this.loadEndTime = - 1;
					this.hsmName = "SWFIP" + this.hsmID + "_" + this.mediaPath ;
					this.startPulse (1000 / 24 );
					return null;
				}
				case EXIT_EVT :
				{
					trace("==============================PRELOADING END =================================");
					this.loadEndTime = getTimer ();
					var dur = this.loadEndTime - this.loadStartTime;
					this.clipSize = (this.clipSize == null) ? this.shell_mc.ph_mc.getBytesTotal () : this.clipSize;
					this.calculatedBandwidth = this.clipSize / (dur / 1000);
					trace ("YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY");
					trace ("YYYYY " + this.mediaPath + " SUCCESSFULLY PRELOADED YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY");
				
					//trace ("YYYYY " + this.shell_mc.ph_mc.getBytesTotal () + " getBytesTotal YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY");
					//trace ("YYYYY " + this.mediaTran.size + " passsed in Size in Bytes YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY");
					trace ("YYYYY loaded in " + dur / 1000 + " seconds  = " + this.calculatedBandwidth + " Bytes/Second YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY");
					//trace ("YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY");*/
					trace ("YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY");
					this.stopPulse ();
					return null;
				}
				case PULSE_EVT :
				{
					
					trace("---------------------------------------PULSE---------------------------------------" + this.pauseExitTime );
					//				trace ("shell_mc " + this.shell_mc.ph_mc.width);
					//THESE DON"T WORK! trace ("shell_mc " + this.shell_mc.ph_mc.getBytesLoaded () + " " + this.shell_mc.ph_mc.getBytesTotal () + " shell " + this.shell_mc.width + " ph_mc" + this.shell_mc.ph_mc.width);
					if ( ! this.contentIsLoaded)
					{
						if (this.pauseExitTime == - 1  && this.ph_mc._url != _root._url && this.ph_mc.getBytesLoaded () > 0 && (this.ph_mc.getBytesLoaded () == this.ph_mc.getBytesTotal ()))
						{
							trace ("IMAGE IN MEMORY...waiting for render");
							this.pauseExitTime = getTimer () + 1000;
						} else if (this.pauseExitTime > - 1 && this.pauseExitTime < getTimer ())
						{	
							trace("IMAGE RENDERED " + this.pauseExitTime );
							this.contentIsLoaded = true;
						} else if(this.pauseExitTime > -1){
							trace("IMAGE RENDERING " + this.pauseExitTime );
						}else	{
							trace ("IMAGE NOT LOADED " + this.ph_mc._url + " " + this.ph_mc.getBytesLoaded () + " / " + this.ph_mc.getBytesTotal ());
						}
					} else
					{
						trace ("	 IMAGE  LOADED  " + util.Trace.me (this.mediaTran, "this.mediaTran ", true) + " " + this.ph_mc.width + " " + this.ph_mc.height);
						if (true && this.smooth)
						{
							trace("     IMAGE SMOOTHING " );
							var bitmap : BitmapData = new BitmapData (this.ph_mc.width, this.ph_mc.height, true);
							this.bp_mc.addChildAt (bitmap, this.bp_mc.getNextHighestDepth () , "auto", true);
							bitmap.draw (this.ph_mc);
							/* DEBUGGING
							this.bp_mc.alpha =30;
						   this.bp_mc.x = 150;
						   this.bp_mc.y = 150;
						   this.ph_mc.x = -50;
						   this.ph_mc.y = -150;*/
						//	this.ph_mc.visible = false;
						}
						this._ow = this.shell_mc.width;
						this._oh = this.shell_mc.height;
						this._oxscale = this.shell_mc.scaleX;
						this._oyscale = this.shell_mc.scaleY;
						if (this.autoPlay)
						{
							trace (this + " media: " + this.mediaPath + " ******AUTOPLAY****** ");
							this.setupForPlay ();
							this.Q_TRAN (this.s15_alphafadeIn);
							//this.shell_mc.visible = true;
							
						} else
						{
							trace (this + " media: " + this.mediaPath + " *****awaiting key stroke*******");
							this.Q_TRAN (this.s10_pausedAtBeginning);
						}
					}
					return null;
				}
				case PLAY_EVT :
				case TRANS_IN_EVT :
				{
					this.deferredEvts.push (e);
					return null;
				}
			}
			return this.s2_hasMediaPath ;
		}
		function s10_pausedAtBeginning (e : AEvent) : Function
		{
			this.onFunctionEnter ("s10_pausedAtBeginning-", e, []);
			switch (e)
			{
				case ENTRY_EVT :
				{
					this.setupForPlay ();
					return null;
				}
				case EXIT_EVT :
				{
					return null;
				}
				case PLAY_EVT :
				{
					this.shell_mc.ph_mc.play ();
					this.Q_TRAN (this.s11_playing);
					return null;
				}
				case GOTOANDSTOP_EVT :
				{
					return null;
				}
			}
			return this.s2_hasMediaPath ;
		}
		function s11_playing (e : AEvent) : Function
		{
			this.onFunctionEnter ("s11_playing-", e, []);
			switch (e)
			{
				case ENTRY_EVT :
				{
					this.startPulse (1000 / 24 );
					/*	trace ("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
					trace ("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
					trace ("XXXXXXXXXXXXXXXXXXXXXXXXXXthis.shell_mc.ph_mc.play  " + this.shell_mc.ph_mc + "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
					trace ("XXXXXXXXXXXXXXXXXXXXXXXXXXXthis.shell_mc.visible  " + this.shell_mc.visible + " XXXthis.shell_mc.alpha  " + this.shell_mc.alpha + " XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
					trace ("XXXXXXXXXXXXXXXXXXXXXXXXXXXthis.shell_mc.ph_mc.visible  " + this.shell_mc.ph_mc.visible + " XXXthis.shell_mc.ph_mc.alpha  " + this.shell_mc.ph_mc.alpha + " XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
					trace ("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");*/
					this.shell_mc.ph_mc.play ();
					return null;
				}
				case EXIT_EVT :
				{
					this.stopPulse ();
					return null;
				}
				case STOP_EVT :
				{
					this.shell_mc.ph_mc.stop ();
					this.Q_TRAN (this.s13_pausedInMiddle);
					return null;
				}
				case TRANS_IN_EVT :
				{
					this.Q_TRAN (this.s15_alphafadeIn);
					//	this.shell_mc.visible = true;
					return null;
				}
				case TRANS_OUT_EVT :
				{
					this.Q_TRAN (this.s14_alphafadeOut);
					//	this.shell_mc.visible = false;
					return null;
				}
				case PULSE_EVT :
				{
					if (this.Asize == this.Bsize)
					{
					//	trace ("panning");
						//same scale do nothing
						////PAN HORIZONTAL//////////////
						if (this.Ax == this.By)
						{
							//same position
							
						} else if (this.Ax > this.By)
						{
							//panning left
							//trace ("panning left");
							this._cx += this.xstep;
							//this.shell_mc.x = Math.round (this._cx);
							this.shell_mc.x = this._cx;
						} else if (this.Ax < this.By)
						{
							//panning right
							this._cx += this.xstep;
							//this.shell_mc.x = Math.round (this._cx);
							this.shell_mc.x = this._cx;
						}
						//PAN VERTICAL//////////////////
						if (this.Ay == this.By)
						{
							//same position
							
						} else if (this.Ay > this.By)
						{
							//panning left
							this._cy += this.ystep;
							//this.shell_mc.y = Math.round (this._cy);
							this.shell_mc.y = this._cy;
						} else if (this.Ay < this.By)
						{
							//panning right
							this._cy += this.ystep;
	//						this.shell_mc.y = Math.round (this._cy);
							this.shell_mc.y = this._cy;
						}
					} else if (this.Asize > this.Bsize)
					{
						//zoom out
						this.shell_mc.visible = false;
						this.shell_mc.scaleX += this.xscalestep;
						this.shell_mc.scaleY += this.yscalestep;
				//		trace ("zoom out " + this.xscalestep + " " + this.yscalestep);
						this.shell_mc.width = Math.round (this.shell_mc.width);
						this.shell_mc.height = Math.round (this.shell_mc.height);
						this.shell_mc.y = this.alignV (this.mediaTran.BvertPos, this.mask_mc, this.shell_mc, true);
						this.shell_mc.x = this.alignH (this.mediaTran.BhorzPos, this.mask_mc, this.shell_mc, true);
						this.shell_mc.visible = true;
					} else if (this.Asize < this.Bsize)
					{
						//zoom in
				//		trace ("zoom in " + this.xscalestep + " " + this.yscalestep);
						this.shell_mc.visible = false;
						this.shell_mc.scaleX += this.xscalestep;
						this.shell_mc.scaleY += this.yscalestep;
						this.shell_mc.width = Math.round (this.shell_mc.width);
						this.shell_mc.height = Math.round (this.shell_mc.height);
						this.shell_mc.x = this.alignH (this.mediaTran.BhorzPos, this.mask_mc, this.shell_mc, true);
						this.shell_mc.y = this.alignV (this.mediaTran.BvertPos, this.mask_mc, this.shell_mc, true);
						this.shell_mc.visible = true;
					}
					//trace ("image animation xstep " + this.xstep + " ystep " + this.ystep + " x " + this.shell_mc.x + " y " + this.shell_mc.y);
					return null;
				}
				case GOTOANDSTOP_EVT :
				{
					this.shell_mc.ph_mc.gotoAndStop (1);
					this.Q_TRAN (this.s10_pausedAtBeginning);
					return null;
				}
			}
			return this.s2_hasMediaPath ;
		}
		function s12_stopped (e : AEvent) : Function
		{
			this.onFunctionEnter ("s12_stopped-", e, []);
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
				case STOP_EVT :
				{
					this.shell_mc.ph_mc.gotoAndStop (1);
					this.Q_TRAN (this.s10_pausedAtBeginning);
					return null;
				}
				case PLAY_EVT :
				{
					this.shell_mc.ph_mc.play ();
					this.Q_TRAN (this.s11_playing);
					return null;
				}
				case GOTOANDSTOP_EVT :
				{
					this.shell_mc.ph_mc.gotoAndStop (1);
					this.Q_TRAN (this.s10_pausedAtBeginning);
					return null;
				}
			}
			return this.s2_hasMediaPath ;
		}
		function s13_pausedInMiddle (e : AEvent) : Function
		{
			this.onFunctionEnter ("s13_pausedInMiddle-", e, []);
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
				case STOP_EVT :
				{
					this.shell_mc.ph_mc.gotoAndStop (1);
					this.Q_TRAN (this.s10_pausedAtBeginning);
					return null;
				}
				case PLAY_EVT :
				{
					this.shell_mc.ph_mc.play ();
					this.Q_TRAN (this.s11_playing);
					return null;
				}
				case GOTOANDSTOP_EVT :
				{
					this.shell_mc.ph_mc.gotoAndStop (1);
					this.Q_TRAN (this.s10_pausedAtBeginning);
					return null;
				}
			}
			return this.s2_hasMediaPath ;
		}
		function s14_alphafadeOut (e : AEvent) : Function
		{
			this.onFunctionEnter ("s14_alphafadeOut-", e, []);
			switch (e)
			{
				case ENTRY_EVT :
				{
					this.alpha = 99;
					this.shell_mc.visible = true;
					return null;
				}
				case EXIT_EVT :
				{
					return null;
				}
				case PULSE_EVT :
				{
					trace("fading out");
					this.alpha -= 9;
					if (this.alpha <= 10)
					{
						this.alpha = 1;
						this.shell_mc.visible = false;
						this.Q_TRAN (this.s10_pausedAtBeginning);
					}
					return s11_playing;
				}
			}
			return this.s11_playing ;
		}
		function s15_alphafadeIn (e : AEvent) : Function
		{
			this.onFunctionEnter ("s15_alphafadeIn-", e, []);
			switch (e)
			{
				case ENTRY_EVT :
				{
					this.alpha = 0;
					this.shell_mc.visible = true;
					return null;
				}
				case EXIT_EVT :
				{
					return null;
				}
				case PULSE_EVT :
				{
					trace("fading in");
					this.alpha += 9;
					trace ("alpha  " + this.alpha);
					if (this.alpha >= 90)
					{
						this.alpha = 99;
						this.Q_TRAN (this.s11_playing);
					}
					return s11_playing;
				}
			}
			return this.s11_playing ;
		}
	}
	
}