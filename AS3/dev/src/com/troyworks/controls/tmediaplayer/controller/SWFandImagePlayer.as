package com.troyworks.controls.tmediaplayer.controller { 
	 //import util.SWFUtilBasic;
	//import util.BasicLoader;
	
	import com.troyworks.controls.tmediaplayer.ASynchronizedMediaPlayer;	
	import com.troyworks.hsmf.CogEvent;
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
	public class SWFandImagePlayer extends ASynchronizedMediaPlayer
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
			trace ("AAAAAAAAAAAAAAAA SWFandImagePlayer " + hsmID);
			hsmName = "SWFIP" + hsmID + "-empty";
			hAlign = false;
		}
		public function onLoad () : void {
			trace ("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
			trace ("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
			trace ("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
			trace ("aaaaaaaaaaaaaaaaSWFImagePlayer.onLoad mediaPath: " + mediaPath + " aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
			trace ("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
			trace ("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
			trace ("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
			super.onLoad ();
			//trace ("SWFImagePlayer.onLoadB1 h " + height + " " + width);
			init ();
			//	trace ("SWFImagePlayer.onLoadB2 h " + height + " " + width);
			shell_mc = createEmptyMovieClip ("shell_mc", getNextHighestDepth ());
			ph_mc = shell_mc.createEmptyMovieClip ("ph_mc", shell_mc.getNextHighestDepth ());
			bp_mc = shell_mc.createEmptyMovieClip ("bp_mc", shell_mc.getNextHighestDepth ());
			mask_mc = createEmptyMovieClip ("mask_mc", getNextHighestDepth ());
			trace ("SWFImagePlayer.onLoadB3 h " + height + " " + width);
			 var h : Number = m_height;
			 var w : Number = m_width;
			with (mask_mc )
			{
				graphics.moveTo (0, 0);
				graphics.beginFill (0xFF0000);
				graphics.lineTo (w, 0);
				graphics.lineTo (w, h);
				graphics.lineTo (0, h);
				graphics.endFill ();
			}
			//shell_mc.alpha = 30;
			shell_mc.setMask (mask_mc );
			//	trace ("BBBBBBBBBBBBBBBBBBBBB SWFandImagePlayer.onLoad" + shell_mc + " pl: " + shell_mc.ph_mc);
			//	trace ("BBBBBBBBBBBBBBBBBBBBB SWFandImagePlayer.onLoad" + mask_mc + " pl: " + shell_mc.ph_mc);
			//_quality = "BEST";
			isLoaded = true;
			Q_TRAN (s1_active);
		}
		function setMedia (path : String) : void
		{
			trace ("bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb");
			trace ("bbbbbbbbbbbbbbbbbbbbbbbbbbbbbb SWFImagePlayer.setMedia bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb");
			trace ("bbbbbbbbbbbbbbbbbbbbbbbbbbbbbb " + mediaPath + "  bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb");
			trace ("bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb");
			if (mediaPath == path)
			{
				//same asset;
				
			} else
			{
				mediaPath = (path == null) ? mediaPath : path;
				if (mediaPath == null)
				{
					trace (hsmName + ".loadMedia '" + mediaPath + "' into " + shell_mc.ph_mc);
					shell_mc.ph_mc.unloadMovie ();
					hsmName = "SWFIP" + hsmID + "-emptyx";
					loadStartTime = - 1;
					loadEndTime = - 1;
					pauseExitTime = - 1;
					Q_TRAN (s1_active);
				} else if (mediaPath != null)
				{
					//trace ("Target Size " + A_height + " " + A_width + " " + shell_mc.width + " " + shell_mc.height);
					Q_TRAN (s1_preloadingMedia);
				}
			}
		}
		public function move (x : Number, y : Number) : void {
			x = x;
			y = y;
			//	_cx = 0;
			//	_cy = 0;
		}
		public function setSize (w : Number, h : Number) : void {
			//	width = w;
			//	height = h;
			
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
			shell_mc.width = _ow;
			shell_mc.height = _oh;
			shell_mc.scaleX = _oxscale;
			shell_mc.scaleY = _oyscale;
			// Setup Transition
			if (true)
			{
				Asize = parseInt (mediaTran.Asize.substring (0, mediaTran.Asize.indexOf ("%")));
				shell_mc.scaleX = Asize;
				shell_mc.scaleY = Asize;
				Ax = alignH (mediaTran.AhorzPos, mask_mc, shell_mc, false);
				Ay = alignV (mediaTran.AvertPos, mask_mc, shell_mc, false);
				trace ("Asize " + Asize + " Ax " + Ax + " Ay " + Ay);
				shell_mc.width = Math.round (shell_mc.width);
				shell_mc.height = Math.round (shell_mc.height);
				shell_mc.x = Ax;
				shell_mc.y = Ay;
				_cx = Ax;
				_cy = Ay;
				Bsize = parseInt (mediaTran.Bsize.substring (0, mediaTran.Bsize.indexOf ("%")));
				Bx = alignH (mediaTran.BhorzPos, mask_mc, shell_mc, false);
				By = alignV (mediaTran.BvertPos, mask_mc, shell_mc, false);
				/////////////////////
				_ox = Ax;
				_oy = Ay;
			}
			//////////////////////////
			if (Ax == Bx)
			{
				//same position
			} else if (Ax > Bx)
			{
				//panning left
			} else if (Ax < Bx)
			{
				//panning right
			}
			if (Ay == By)
			{
				//same position
			} else if (Ay > By)
			{
				//panning left
			} else if (Ay < By)
			{
				//panning right
			}
			if (Asize == Bsize)
			{
				//same scale do nothing
			} else if (Asize > Bsize)
			{
				//zoom in
			} else if (Asize < Bsize)
			{
				//zoom out
			}
			 var framesToPlay = trk.length * 24;
			trace ("Bsize " + Bsize + " Bx " + Bx + " By " + By + " duration " + trk.length + " frames: " + framesToPlay + " Bscale " + Bscale);
			//figure out what to do during the transition (eventually need duration in this calculations);
			xstep = (Bx - Ax) / framesToPlay;
			ystep = (By - Ay) / framesToPlay;
			 var Bscale = (Bsize - Asize) / framesToPlay;
			trace ("zoom change " + (Bsize - Asize) + " " + Bscale);
			xscalestep = Bscale ;
			yscalestep = Bscale ;
			//var alphstep
		}
		//growing
		//shrinking
		//moving
		//
		/*.................................................................*/
		function awaitingMovieAttachOnLoad (e : CogEvent) : Function
		{
		//	onFunctionEnter ("awaitingMovieAttachOnLoad-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				{
					//	swf.ui_preload.visible = false;
					//	skin_mc.visible = true;
					//	skin_mc.gotoAndPlay ("active");
					return null;
				}
				case SIG_EXIT :
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
		function s1_active (e : CogEvent) : Function
		{
		//	onFunctionEnter ("s1_active-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				{
					//	swf.ui_preload.visible = false;
					//	skin_mc.visible = true;
					//	skin_mc.gotoAndPlay ("active");
					return null;
				}
				case SIG_EXIT :
				{
					return null;
				}
				case INIT_EVT :
				{
					if (mediaPath != null)
					{
						Q_TRAN (s2_hasMediaPath);
					} else
					{
						Q_TRAN (s1_awaitingMediaPath);
					}
					return null;
				}
			}
			return s_top;
		}
		function s1_awaitingMediaPath (e : CogEvent) : Function
		{
		//	onFunctionEnter ("s1_awaitingMediaPath-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				{
					return null;
				}
				case SIG_EXIT :
				{
					return null;
				}
			}
			return s1_active ;
		}
		function s2_hasMediaPath (e : CogEvent) : Function
		{
		//	onFunctionEnter ("s2_hasMediaPath-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				{
					return null;
				}
				case SIG_EXIT :
				{
					return null;
				}
				case INIT_EVT :
				{
					if (autoPreload)
					{
						trace (this + " media: " + mediaPath + " ******AUTO PRELOAD****** ");
						Q_TRAN (s1_preloadingMedia);
					}
					return null;
				}
			}
			return s1_active ;
		}
		function s1_preloadingMedia (e : CogEvent) : Function
		{
		//	onFunctionEnter ("s1_preloadingMedia-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				{
					trace("==============================PRELOADING START =================================");
					//	shell_mc.setMask(this);
					shell_mc.visible = false;
					shell_mc.scaleX = 100;
					shell_mc.scaleY = 100;
					shell_mc.x = 0;
					shell_mc.y = 0;
					_cx = 0;
					_cy = 0;
					shell_mc.alpha = 100;
					contentIsLoaded = false;
					trace (hsmName + ".loadMedia '" + mediaPath + "' into " + shell_mc.ph_mc);
					log.debug ("SWFandImagePlayer.loadMedia '" + mediaPath + "' ");
					shell_mc.ph_mc.loadMovie (mediaPath );
					loadStartTime = getTimer ();
					loadEndTime = - 1;
					hsmName = "SWFIP" + hsmID + "_" + mediaPath ;
					startPulse (1000 / 24 );
					return null;
				}
				case SIG_EXIT :
				{
					trace("==============================PRELOADING END =================================");
					loadEndTime = getTimer ();
					var dur = loadEndTime - loadStartTime;
					clipSize = (clipSize == null) ? shell_mc.ph_mc.getBytesTotal () : clipSize;
					calculatedBandwidth = clipSize / (dur / 1000);
					trace ("YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY");
					trace ("YYYYY " + mediaPath + " SUCCESSFULLY PRELOADED YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY");
				
					//trace ("YYYYY " + shell_mc.ph_mc.getBytesTotal () + " getBytesTotal YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY");
					//trace ("YYYYY " + mediaTran.size + " passsed in Size in Bytes YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY");
					trace ("YYYYY loaded in " + dur / 1000 + " seconds  = " + calculatedBandwidth + " Bytes/Second YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY");
					//trace ("YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY");*/
					trace ("YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY");
					stopPulse ();
					return null;
				}
				case SIG_PULSE :
				{
					
					trace("---------------------------------------PULSE---------------------------------------" + pauseExitTime );
					//				trace ("shell_mc " + shell_mc.ph_mc.width);
					//THESE DON"T WORK! trace ("shell_mc " + shell_mc.ph_mc.getBytesLoaded () + " " + shell_mc.ph_mc.getBytesTotal () + " shell " + shell_mc.width + " ph_mc" + shell_mc.ph_mc.width);
					if ( ! contentIsLoaded)
					{
						if (pauseExitTime == - 1  && ph_mc._url != _root._url && ph_mc.getBytesLoaded () > 0 && (ph_mc.getBytesLoaded () == ph_mc.getBytesTotal ()))
						{
							trace ("IMAGE IN MEMORY...waiting for render");
							pauseExitTime = getTimer () + 1000;
						} else if (pauseExitTime > - 1 && pauseExitTime < getTimer ())
						{	
							trace("IMAGE RENDERED " + pauseExitTime );
							contentIsLoaded = true;
						} else if(pauseExitTime > -1){
							trace("IMAGE RENDERING " + pauseExitTime );
						}else	{
							trace ("IMAGE NOT LOADED " + ph_mc._url + " " + ph_mc.getBytesLoaded () + " / " + ph_mc.getBytesTotal ());
						}
					} else
					{
						trace ("	 IMAGE  LOADED  " + util.Trace.me (mediaTran, "mediaTran ", true) + " " + ph_mc.width + " " + ph_mc.height);
						if (true && smooth)
						{
							trace("     IMAGE SMOOTHING " );
							var bitmap : BitmapData = new BitmapData (ph_mc.width, ph_mc.height, true);
							bp_mc.addChildAt (bitmap, bp_mc.getNextHighestDepth () , "auto", true);
							bitmap.draw (ph_mc);
							/* DEBUGGING
							bp_mc.alpha =30;
						   bp_mc.x = 150;
						   bp_mc.y = 150;
						   ph_mc.x = -50;
						   ph_mc.y = -150;*/
						//	ph_mc.visible = false;
						}
						_ow = shell_mc.width;
						_oh = shell_mc.height;
						_oxscale = shell_mc.scaleX;
						_oyscale = shell_mc.scaleY;
						if (autoPlay)
						{
							trace (this + " media: " + mediaPath + " ******AUTOPLAY****** ");
							setupForPlay ();
							Q_TRAN (s15_alphafadeIn);
							//shell_mc.visible = true;
							
						} else
						{
							trace (this + " media: " + mediaPath + " *****awaiting key stroke*******");
							Q_TRAN (s10_pausedAtBeginning);
						}
					}
					return null;
				}
				case PLAY_EVT :
				case TRANS_IN_EVT :
				{
					deferredEvts.push (e);
					return null;
				}
			}
			return s2_hasMediaPath ;
		}
		function s10_pausedAtBeginning (e : CogEvent) : Function
		{
		//	onFunctionEnter ("s10_pausedAtBeginning-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				{
					setupForPlay ();
					return null;
				}
				case SIG_EXIT :
				{
					return null;
				}
				case PLAY_EVT :
				{
					shell_mc.ph_mc.play ();
					Q_TRAN (s11_playing);
					return null;
				}
				case GOTOANDSTOP_EVT :
				{
					return null;
				}
			}
			return s2_hasMediaPath ;
		}
		function s11_playing (e : CogEvent) : Function
		{
		//	onFunctionEnter ("s11_playing-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				{
					startPulse (1000 / 24 );
					/*	trace ("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
					trace ("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
					trace ("XXXXXXXXXXXXXXXXXXXXXXXXXXshell_mc.ph_mc.play  " + shell_mc.ph_mc + "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
					trace ("XXXXXXXXXXXXXXXXXXXXXXXXXXXshell_mc.visible  " + shell_mc.visible + " XXXshell_mc.alpha  " + shell_mc.alpha + " XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
					trace ("XXXXXXXXXXXXXXXXXXXXXXXXXXXshell_mc.ph_mc.visible  " + shell_mc.ph_mc.visible + " XXXshell_mc.ph_mc.alpha  " + shell_mc.ph_mc.alpha + " XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
					trace ("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");*/
					shell_mc.ph_mc.play ();
					return null;
				}
				case SIG_EXIT :
				{
					stopPulse ();
					return null;
				}
				case STOP_EVT :
				{
					shell_mc.ph_mc.stop ();
					Q_TRAN (s13_pausedInMiddle);
					return null;
				}
				case TRANS_IN_EVT :
				{
					Q_TRAN (s15_alphafadeIn);
					//	shell_mc.visible = true;
					return null;
				}
				case TRANS_OUT_EVT :
				{
					Q_TRAN (s14_alphafadeOut);
					//	shell_mc.visible = false;
					return null;
				}
				case SIG_PULSE :
				{
					if (Asize == Bsize)
					{
					//	trace ("panning");
						//same scale do nothing
						////PAN HORIZONTAL//////////////
						if (Ax == By)
						{
							//same position
							
						} else if (Ax > By)
						{
							//panning left
							//trace ("panning left");
							_cx += xstep;
							//shell_mc.x = Math.round (_cx);
							shell_mc.x = _cx;
						} else if (Ax < By)
						{
							//panning right
							_cx += xstep;
							//shell_mc.x = Math.round (_cx);
							shell_mc.x = _cx;
						}
						//PAN VERTICAL//////////////////
						if (Ay == By)
						{
							//same position
							
						} else if (Ay > By)
						{
							//panning left
							_cy += ystep;
							//shell_mc.y = Math.round (_cy);
							shell_mc.y = _cy;
						} else if (Ay < By)
						{
							//panning right
							_cy += ystep;
	//						shell_mc.y = Math.round (_cy);
							shell_mc.y = _cy;
						}
					} else if (Asize > Bsize)
					{
						//zoom out
						shell_mc.visible = false;
						shell_mc.scaleX += xscalestep;
						shell_mc.scaleY += yscalestep;
				//		trace ("zoom out " + xscalestep + " " + yscalestep);
						shell_mc.width = Math.round (shell_mc.width);
						shell_mc.height = Math.round (shell_mc.height);
						shell_mc.y = alignV (mediaTran.BvertPos, mask_mc, shell_mc, true);
						shell_mc.x = alignH (mediaTran.BhorzPos, mask_mc, shell_mc, true);
						shell_mc.visible = true;
					} else if (Asize < Bsize)
					{
						//zoom in
				//		trace ("zoom in " + xscalestep + " " + yscalestep);
						shell_mc.visible = false;
						shell_mc.scaleX += xscalestep;
						shell_mc.scaleY += yscalestep;
						shell_mc.width = Math.round (shell_mc.width);
						shell_mc.height = Math.round (shell_mc.height);
						shell_mc.x = alignH (mediaTran.BhorzPos, mask_mc, shell_mc, true);
						shell_mc.y = alignV (mediaTran.BvertPos, mask_mc, shell_mc, true);
						shell_mc.visible = true;
					}
					//trace ("image animation xstep " + xstep + " ystep " + ystep + " x " + shell_mc.x + " y " + shell_mc.y);
					return null;
				}
				case GOTOANDSTOP_EVT :
				{
					shell_mc.ph_mc.gotoAndStop (1);
					Q_TRAN (s10_pausedAtBeginning);
					return null;
				}
			}
			return s2_hasMediaPath ;
		}
		function s12_stopped (e : CogEvent) : Function
		{
			onFunctionEnter ("s12_stopped-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				{
					return null;
				}
				case SIG_EXIT :
				{
					return null;
				}
				case STOP_EVT :
				{
					shell_mc.ph_mc.gotoAndStop (1);
					Q_TRAN (s10_pausedAtBeginning);
					return null;
				}
				case PLAY_EVT :
				{
					shell_mc.ph_mc.play ();
					Q_TRAN (s11_playing);
					return null;
				}
				case GOTOANDSTOP_EVT :
				{
					shell_mc.ph_mc.gotoAndStop (1);
					Q_TRAN (s10_pausedAtBeginning);
					return null;
				}
			}
			return s2_hasMediaPath ;
		}
		function s13_pausedInMiddle (e : CogEvent) : Function
		{
			onFunctionEnter ("s13_pausedInMiddle-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				{
					return null;
				}
				case SIG_EXIT :
				{
					return null;
				}
				case STOP_EVT :
				{
					shell_mc.ph_mc.gotoAndStop (1);
					Q_TRAN (s10_pausedAtBeginning);
					return null;
				}
				case PLAY_EVT :
				{
					shell_mc.ph_mc.play ();
					Q_TRAN (s11_playing);
					return null;
				}
				case GOTOANDSTOP_EVT :
				{
					shell_mc.ph_mc.gotoAndStop (1);
					Q_TRAN (s10_pausedAtBeginning);
					return null;
				}
			}
			return s2_hasMediaPath ;
		}
		function s14_alphafadeOut (e : CogEvent) : Function
		{
			onFunctionEnter ("s14_alphafadeOut-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				{
					alpha = 99;
					shell_mc.visible = true;
					return null;
				}
				case SIG_EXIT :
				{
					return null;
				}
				case SIG_PULSE :
				{
					trace("fading out");
					alpha -= 9;
					if (alpha <= 10)
					{
						alpha = 1;
						shell_mc.visible = false;
						Q_TRAN (s10_pausedAtBeginning);
					}
					return s11_playing;
				}
			}
			return s11_playing ;
		}
		function s15_alphafadeIn (e : CogEvent) : Function
		{
			onFunctionEnter ("s15_alphafadeIn-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				{
					alpha = 0;
					shell_mc.visible = true;
					return null;
				}
				case SIG_EXIT :
				{
					return null;
				}
				case SIG_PULSE :
				{
					trace("fading in");
					alpha += 9;
					trace ("alpha  " + alpha);
					if (alpha >= 90)
					{
						alpha = 99;
						Q_TRAN (s11_playing);
					}
					return s11_playing;
				}
			}
			return s11_playing ;
		}
	}
	
}