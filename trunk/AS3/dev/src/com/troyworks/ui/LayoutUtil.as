/**
 * ...
 * @author Default
 * @version 0.1
 */

package com.troyworks.ui {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.printing.*;	

	public class LayoutUtil {

		/*******************************************************
		 * for a given movie passed in capture it's x, y, width, height, into 
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
		public static function snapshotDimensions(a_mc : DisplayObject, to_mc : IDisplayObjectSnapShot = null, override_width : Number = NaN, override_height : Number = NaN) : IDisplayObjectSnapShot {
			trace("-----------------------------------------------------");
			trace("CALL snapshotDimensions");
			var s_mc : DisplayObject = a_mc;
			if(to_mc == null) {
				//new DisplayObjectSnapShot();
				to_mc = IDisplayObjectSnapShot(new DisplayObjectSnapShot());
			}
			//////Find the viewport on the content/////////////////////////
			// note that when a movie clip is exported from the library, a wrapper swf is created
			//
			var viewport : DisplayObject = null;
			var wholeObject : DisplayObject = null;
			if(a_mc is DisplayObjectContainer) {
				var doC : DisplayObjectContainer = DisplayObjectContainer(a_mc);
				viewport = doC.getChildByName("viewport_mc");
				wholeObject = doC.getChildByName("slug_mc");
			}
			/////Get the original dimension pre scaling and positioning ////////////
			if (viewport != null) {
				trace("has a clipping region!!!!!!!!!!!!!!");
				
				//Modified by Ksenia
				//s_mc = viewport;
				
				to_mc.hasViewport = true;
				//offset between viewport and published content.
				to_mc.vp_ox_offset = viewport.x;
				to_mc.vp_oy_offset = viewport.y;
				trace("viewport offset " + to_mc.vp_ox_offset + ", " + to_mc.vp_oy_offset); 
				to_mc.vp_owidth = viewport.width;
				to_mc.vp_oheight = viewport.height;
								
				trace("clip.width " + a_mc.width + " center " + a_mc.width / 2);
				trace("a_mc.scaleX "+a_mc.scaleX+" a_mc.scaleY "+a_mc.scaleY);				
				to_mc.vp_ocx_offset = (a_mc.width / a_mc.scaleX) / 2 - (viewport.x + viewport.width / 2);
				to_mc.vp_ocy_offset = (a_mc.height / a_mc.scaleY) / 2 - (viewport.y + viewport.height / 2);
				trace(" offset x " + viewport.x + " y " + viewport.y);
				trace(" offset vcx " + to_mc.vp_ocx_offset + " vcy " + to_mc.vp_ocy_offset);
				//scale factor between viewport and actual (masked) movie dimensions (as mask shows all stuff on stage)

				//Added by Ksenia
				if (wholeObject != null)
				{
					to_mc.owidth = wholeObject.width;
					to_mc.oheight = wholeObject.height;
				}
				else 
				{
					to_mc.owidth = a_mc.width;
					to_mc.oheight = a_mc.height;
				}
				
				to_mc.vp_owscale = (viewport.width / to_mc.owidth);
				to_mc.vp_ohscale = (viewport.height / to_mc.oheight);
				trace("vp_owscale " + to_mc.vp_owscale + "  " + viewport.width + "/" + to_mc.owidth + " ?= " + (viewport.width / to_mc.owidth)); 
				trace("vp_ohscale " + to_mc.vp_ohscale + "  " + viewport.height + "/" + to_mc.oheight + " ?= " + (viewport.height / to_mc.oheight)); 
				
				to_mc.o_wh_asp = s_mc.width / s_mc.height;
				to_mc.o_hw_asp = s_mc.height / s_mc.width;
				to_mc.width = s_mc.width;
				to_mc.height = s_mc.height;
				to_mc.scaleX = s_mc.scaleX;
				to_mc.scaleY = s_mc.scaleY;
			} else {
				// NO viewport
				to_mc.hasViewport = false;
				to_mc.vp_ox_offset = 0;
				to_mc.vp_oy_offset = 0;
				to_mc.vp_owscale = 1;
				to_mc.vp_ohscale = 1;
				
				//Added by Ksenia
				if (wholeObject != null)
				{
					to_mc.owidth = wholeObject.width;
					to_mc.oheight = wholeObject.height;
					to_mc.vp_owidth = wholeObject.width;
					to_mc.vp_oheight = wholeObject.height;
				}
				else 
				{
					to_mc.owidth = s_mc.width;
					to_mc.oheight = s_mc.height;
					to_mc.vp_owidth = s_mc.width;
					to_mc.vp_oheight = s_mc.height;
				}
			}
			to_mc.ox = s_mc.x;
			to_mc.oy = s_mc.y;
			to_mc.owidth = s_mc.width;
			to_mc.oheight = s_mc.height;
			to_mc.oxscale = s_mc.scaleX;
			to_mc.oyscale = s_mc.scaleY;
			//actual height
			//			to_mc.oawidth = Math.round(to_mc.width / to_mc.scaleX * 100);
			//			to_mc.oaheight = Math.round(to_mc.height / to_mc.scaleY * 100);
			to_mc.oawidth = Math.round(to_mc.width / to_mc.scaleX);
			to_mc.oaheight = Math.round(to_mc.height / to_mc.scaleY);
			
			to_mc.o_wh_asp = s_mc.width / s_mc.height;
			to_mc.o_hw_asp = s_mc.height / s_mc.width;
			//	trace( util.Trace.me(to_mc, "ERROR SNAPSHOT DIMENSIONS ", true));
			//	trace(" captureOriginalAspect "+to_mc._url+" "+to_mc.width);
			
			trace("-----------------------------------------------------");
			
			return to_mc;
		}

		/***********************************
		 * given 2 clips and a range of properties
		 * make them match 
		 * */
		public static const VISIBILE_PROPS : Array = ["alpha", "visible", "rotation", "xscale", "yscale", "x", "y"];

		public static function matchClips(mc1 : DisplayObject, mc2 : DisplayObject, props : Array = null) {		
			trace("Matching");
			if(props == null) {
				props = VISIBILE_PROPS;
			}
			var L : Number = props.length;
			while (--L) {
				mc1[props[L]] = mc2[props[L]];
			}
		}

		public function center(still_mc : DisplayObject, moving_mc : DisplayObject) : void {
			//Center
			//	trace(this.name + "BaseComponent.center()" + clip.stage.stageWidth + " " + clip.stage.stageHeight  + " " + this.width + " " + this.height);
			moving_mc.x = (still_mc.stage.stageWidth - moving_mc.width) / 2;
			moving_mc.y = (still_mc.stage.stageHeight - moving_mc.height) / 2;
			//	trace("setting to x " + this.x + " y " + this.y);
		}

		public static function getAlignH(still_mc : Object, moving_mc : DisplayObject, movingSnapShot : IDisplayObjectSnapShot = null, x : String = "CENTER",  snapToWholePixel : Boolean = false) : Number {
			trace("alignH " + x + " " + still_mc + " " + moving_mc + " snap " + snapToWholePixel);
			var r : Number = 0;
			if(movingSnapShot == null) {
				trace("CREATING SNAPSHOT");
				movingSnapShot = snapshotDimensions(moving_mc);
			}

			switch (x.toUpperCase()) {
				//assume that mask is at 0,0 so no xpos is needed
				case "CENTER" :
					var offsetC : Number = ( movingSnapShot.hasViewport) ? (movingSnapShot.vp_ocx_offset * moving_mc.scaleX) : 0;
					trace("OFFSET of center " + offsetC) ;		
					if(still_mc.width > moving_mc.width) {
						trace("still > moviing "); 
						r = ((still_mc.width - moving_mc.width) / 2) + still_mc.x + offsetC;
					}else if(still_mc.width < moving_mc.width) {
						trace("moving < still%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
						r = still_mc.x - ((moving_mc.width - still_mc.width) / 2 ) + offsetC;
					}else {
						trace("moving == still");
						//equal
						r = still_mc.x + offsetC;
					}
					break;
				case "RIGHT" :
					r = (still_mc.x + still_mc.width - moving_mc.width) + (moving_mc.width - ((movingSnapShot.vp_ox_offset + movingSnapShot.vp_owidth) * moving_mc.scaleX));
					break;
				case "LEFT" :
					r = still_mc.x - (movingSnapShot.vp_ox_offset * moving_mc.scaleX);
					break;
				default :
					return 0;
			}
			if (snapToWholePixel) {
				return Math.round(r);
			}else {
				return r;
			}
		}

		public static function getAlignV(still_mc : Object, moving_mc : DisplayObject, movingSnapShot : IDisplayObjectSnapShot = null, y : String = "MIDDLE",  snapToWholePixel : Boolean = false) : Number {
			
			trace("CALL getAlignV");
			trace ("alignV " + y+ " still_mc.y=" + still_mc.y + " moving_mc.height=" + moving_mc.height);
			var r : Number = 0;
			if(movingSnapShot == null) {
				movingSnapShot = snapshotDimensions(moving_mc);
			}
			//Added by Ksenia					
			var scaleH = moving_mc.height/movingSnapShot.oheight;					
			var vp_cur_yoffset = movingSnapShot.vp_oy_offset * scaleH;
			switch (y.toUpperCase()) {
				//assume that mask is at 0,0 so no ypos is needed
				case "CENTER" :
				case "MIDDLE" :
					var offsetC : Number = ( movingSnapShot.hasViewport) ? (movingSnapShot.vp_ocy_offset * moving_mc.scaleY) : 0;
					trace("OFFSET of center " + offsetC) ;		
					if(still_mc.height > moving_mc.height) {
						trace("still > moving "); 
						r = ((still_mc.height - moving_mc.height) / 2) + still_mc.y + offsetC;
					}else if(still_mc.height < moving_mc.height) {
						trace("moving < still%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
						r = still_mc.y - ((moving_mc.height - still_mc.height) / 2 ) + offsetC;
					}else {
						trace("moving == still");
						//equal
						r = still_mc.y + offsetC;
					}
					break;
				case "BOTTOM" :
					//Added by Ksenia
					var vp_cur_height = moving_mc.height * movingSnapShot.vp_ohscale;
					r = (still_mc.y + still_mc.height - moving_mc.height) + (moving_mc.height - (vp_cur_yoffset + vp_cur_height));
					//r = (still_mc.y + still_mc.height - moving_mc.height) + (moving_mc.height - (movingSnapShot.vp_oy_offset + movingSnapShot.vp_oheight));
					break;
				case "TOP" :
					//Added by Ksenia
					r = still_mc.y - vp_cur_yoffset;
					//r = still_mc.y - movingSnapShot.vp_oy_offset;
					break;
				default :
					return 0;
			}
			if (snapToWholePixel) {
				return Math.round(r);
			}else {
				return r;
			}
		}

		public static function scaleTo(still_mc : DisplayObject, moving_mc : DisplayObject , movingSnapShot : IDisplayObjectSnapShot = null, 
			scaleType : String = "CENTER", override_width : Number = NaN, override_height : Number = NaN) : void 
		{
			trace("HIGHLIGHT SCALETO "+scaleType);
			if(moving_mc.stage != null) {
				trace("clip.stage.stageWidth " + moving_mc.stage.stageWidth + " still  mc " + still_mc.width + " moving  mc " + moving_mc.width + " override " + override_width);
				trace("clip.stage.stageHeight " + moving_mc.stage.stageHeight + " still  mc " + still_mc.height + " moving  mc " + moving_mc.height + " override " + override_height);
			}
			if(movingSnapShot == null) {
				movingSnapShot = snapshotDimensions(moving_mc);
			}
			////////////////////////////////////
			//  target to scalee's actual height 
			////////////////////////////////////
			var	t_w : Number = NaN;
			var t_h : Number = NaN;
			
			if(movingSnapShot.hasViewport) {
				trace("using viewport");
				t_w = movingSnapShot.vp_owidth;
				t_h = movingSnapShot.vp_oheight;				
			}else {
				trace(" not using viewport");
				if(!movingSnapShot.oawidth) {
					trace("using current actual width");
					t_w = moving_mc.width;
				}else {
					trace("using original actual width");
					t_w = movingSnapShot.oawidth;
				}
				if(!movingSnapShot.oaheight) {
					trace("using current actual height");
					t_h = moving_mc.height;
				}else {
					trace("using original actual height");
					t_h = movingSnapShot.oaheight;
				}				
			}
			
			////////////////////////////////////
			//   desired height 
			////////////////////////////////////
			var dw : Number = (isNaN(override_width)) ? still_mc.width : override_width;
			var dh : Number = (isNaN(override_height)) ? still_mc.height : override_height;
			var scaleW : Number = (!movingSnapShot.hasViewport) ? 1 : movingSnapShot.vp_owscale;
			var scaleH : Number = (!movingSnapShot.hasViewport) ? 1 : movingSnapShot.vp_ohscale;
	
			trace("  scaling W " + scaleW + "  H " + scaleH);
			var still_asp : Number = dw / dh;
			//o_wh_asp and o_hw_asp are the original captured aspect ratio,
			//this is as captured from the IDE, and NOT the actionscript,
			//in order to get accurate onscreen representation.
			//scale  the largest photo to smallest desired dimension based
			// on the relative aspect ratio
			
			//Added by Ksenia
			t_w = moving_mc.width * scaleW;
			t_h = moving_mc.height * scaleH;
			
			trace("CUR DIMENSIONS w:"+moving_mc.width +" h:"+moving_mc.height);
			trace("PHOTO DIMENSIONS w:" + t_w + " h:" + t_h + " asp " + p_asp);
			trace("DESIRED DIMENTSION w:" + dw + " h: " + dh + " asp " + still_asp);
			
			var asRatios : Number = (p_asp / still_asp);
			trace("aspect ratio " + asRatios + "  " + still_asp);
			
			var m_asp : Number = moving_mc.width / moving_mc.height;
			var v_asp : Number = movingSnapShot.vp_owidth / movingSnapShot.vp_oheight;
			
			trace ("mc width "+moving_mc.width+" height "+ moving_mc.height);
			trace("original width "+movingSnapShot.vp_owidth+" height "+movingSnapShot.vp_oheight);
			
			trace("MASP " + m_asp + " " + v_asp + " " + m_asp / v_asp);
			var p_asp : Number = t_w / t_h;
			var p2_asp : Number = t_h / t_w;
	
			var resizeAnyWay : Boolean = (asRatios == 1) && t_w != dw;
			trace("resizeAnyWay "+resizeAnyWay);
			var ww : Number = t_w / dw;
			var hh : Number = t_h / dh;
		
			trace("ww= "+ww+" hh= "+hh);
			
			var resize : String;
			switch (scaleType) 
			{
				case "CENTER":
					if(ww > hh) {
						resize = "W";
					}else if (ww < hh) {
						resize = "H";
					}else if(ww == hh) {
						resize = "F";
					}
					break;
				case "CROP":
					if(ww > hh) {
						resize = "H";
					}else if (ww < hh) {
						resize = "W";
					}else if(ww == hh) {
						resize = "F";
					}
					break;
				default:
					resize = "F";
					break;
			}
			
			var sn : IDisplayObjectSnapShot;
			if(resize == "W") {
				trace("WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW");
				trace("resizing width first to:" + dw);
				if(false){
					var tmp : Number = p_asp;
					p_asp = p2_asp;
					p2_asp = tmp;
				}
				trace("scaleW = "+scaleW+" "+" dw "+dw+" dh "+dh+" ww "+ww);
				trace ("mc width "+moving_mc.width+" height "+ moving_mc.height);
				var newWidth:Number = moving_mc.width/ww;
				var newHeight:Number = moving_mc.height/ww;
				trace("width "+moving_mc.width+" / "+ww+" = "+newWidth);
				trace("height "+moving_mc.height+" / "+ww+" = "+newHeight);
				
				moving_mc.width = newWidth;
				moving_mc.height = newHeight;
				
				trace("AFTER " + moving_mc.width + " " + moving_mc.height);
				
				sn = new DisplayObjectSnapShot();
				sn.width = dw;
				sn.height = dh;
				sn.x = still_mc.x;
				sn.y = still_mc.y;
				moving_mc.x = getAlignH(sn, moving_mc);
				moving_mc.y = getAlignV(sn, moving_mc);
			} else if (resize == "H") {
				trace("HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH");
				trace("resizing height first to:" + dh);
				if(m_asp / v_asp != 1) {
					var tmp2 : Number = p_asp;
					p_asp = p2_asp;
					p2_asp = tmp2;
				}
				
				trace("BEFORE " + moving_mc.width + " " + moving_mc.height);
				//Added by Ksenia
				moving_mc.width = moving_mc.width / hh;
				moving_mc.height = moving_mc.height / hh;
				trace("AFTER " + moving_mc.width + " " + moving_mc.height);
				
				sn = new DisplayObjectSnapShot();
				sn.width = dw;
				sn.height = dh;
				sn.x = still_mc.x;
				sn.y = still_mc.y;
				moving_mc.x = getAlignH(sn, moving_mc);
				moving_mc.y = getAlignV(sn, moving_mc);
			} else {
				trace("FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF");
				trace("resizing width: " + dh+" and height: "+dw);
				
				moving_mc.width = moving_mc.width / ww;
				moving_mc.height = moving_mc.height / hh;
				
				sn = new DisplayObjectSnapShot();
				sn.width = dw;
				sn.height = dh;
				sn.x = still_mc.x;
				sn.y = still_mc.y;
				moving_mc.x = getAlignH(sn, moving_mc);
				moving_mc.y = getAlignV(sn, moving_mc);
			}
			trace("HIGHLIGHTO SCALETO "+scaleType+" res:  " + moving_mc.width + "  " + moving_mc.height);
		}
		
		public static function printImagePortrait(view:MovieClip, sO : IDisplayObjectSnapShot, background_mc:MovieClip):void
		{
			if (view == null) return;
		    var pj:PrintJob = new PrintJob();
		    pj.start();
		    var rect : Rectangle;
		    var pjo:PrintJobOptions;
		    
		    var initW:Number = view.width;
			var initH:Number = view.height;
			var initX:Number = view.x;
			var initY:Number = view.y;
			var xOffset:int = 0;
			var yOffset:int = 0;
			var vp_curWidth:Number = 0;
			var vp_curHeight:Number = 0;
			var curScale:Number = 1;
			var initScrRect:Rectangle;
				
		    if(pj.orientation == PrintJobOrientation.PORTRAIT)
			{
				pjo = new PrintJobOptions();
				pjo.printAsBitmap = true;
				
				LayoutUtil.scaleTo(background_mc, view, sO, "CENTER", pj.pageWidth-80, pj.pageHeight-80);
			
				curScale = view.width/sO.owidth;
				
				vp_curWidth = view.width * sO.vp_owscale;
				vp_curHeight = view.height * sO.vp_ohscale;
				
				xOffset = (pj.pageWidth-vp_curWidth)/2/curScale;
				yOffset = (pj.pageHeight-vp_curHeight)/2/curScale;
				
				rect = new Rectangle(-xOffset, -yOffset, sO.vp_owidth+xOffset, sO.vp_oheight+yOffset);

				initScrRect = new Rectangle(0,0, view.width, view.height);	
				
				if (sO.hasViewport) view.scrollRect = new Rectangle(sO.vp_ox_offset, sO.vp_oy_offset, sO.vp_owidth, sO.vp_oheight);
					  
				pj.addPage(Sprite(view), rect, pjo);                             
				pj.send();
				
				if (sO.hasViewport) view.scrollRect = initScrRect;
		    }
			else
			{
		    	pjo = new PrintJobOptions();
				pjo.printAsBitmap = true;
				
				LayoutUtil.scaleTo(background_mc, view, sO, "CENTER", pj.pageHeight-80, pj.pageWidth-80);
				curScale = view.width/sO.owidth;

				view.rotation = 90;
				
				view.x = initX;
		    	view.y = initY;
		    	
		    	vp_curWidth = view.width * sO.vp_ohscale;
				vp_curHeight = view.height * sO.vp_owscale;
				
				yOffset = (pj.pageWidth-vp_curWidth)/2/curScale;
				xOffset = (pj.pageHeight-vp_curHeight)/2/curScale;
				
				rect = new Rectangle(-xOffset, 0, sO.vp_owidth+xOffset, sO.vp_oheight+yOffset);
													 
				initScrRect = new Rectangle(0,0,view.width, view.height);
				if (sO.hasViewport) view.scrollRect = new Rectangle(sO.vp_ox_offset, sO.vp_oy_offset, sO.vp_owidth, sO.vp_oheight);
								
		        pj.addPage(Sprite(view), rect, pjo);		        
		        pj.send();
		        
		        if (sO.hasViewport) view.scrollRect = initScrRect;
		        view.rotation = 0;
		    }
		    view.width = initW * sO.vp_owscale;
			view.height = initH * sO.vp_ohscale;
			view.x = initX;
		    view.y = initY;	
		}
		
		public static function printImageLandscape(view:MovieClip, sO : IDisplayObjectSnapShot, background_mc:MovieClip):void
		{
			if (view == null) return;
		    var pj:PrintJob = new PrintJob();
		    pj.start();
		    var rect : Rectangle;
		    var pjo:PrintJobOptions;
		    
		    var initW:Number = view.width;
			var initH:Number = view.height;
			var initX:Number = view.x;
			var initY:Number = view.y;
			var xOffset:int = 0;
			var yOffset:int = 0;
			var vp_curWidth:Number = 0;
			var vp_curHeight:Number = 0;
			var curScale:Number = 1;
			var initScrRect:Rectangle;
				
		    if(pj.orientation == PrintJobOrientation.LANDSCAPE)
			{
				pjo = new PrintJobOptions();
				pjo.printAsBitmap = true;
				
				LayoutUtil.scaleTo(background_mc, view, sO, "CENTER", pj.pageWidth-80, pj.pageHeight-80);
				curScale = view.width/sO.owidth;
					  
				vp_curWidth = view.width * sO.vp_owscale;
				vp_curHeight = view.height * sO.vp_ohscale;
				
				xOffset = (pj.pageWidth-vp_curWidth)/2/curScale;
				yOffset = (pj.pageHeight-vp_curHeight)/2/curScale;
		
				trace("Landscape");
				trace("xOffset "+xOffset+" yOffset "+yOffset);
				
				rect = new Rectangle(-xOffset, -yOffset, sO.vp_owidth+xOffset, sO.vp_oheight+yOffset);
				
				initScrRect = new Rectangle(0,0,view.width, view.height);				
				if (sO.hasViewport) view.scrollRect = new Rectangle(sO.vp_ox_offset, sO.vp_oy_offset, sO.vp_owidth, sO.vp_oheight);
				
				pj.addPage(Sprite(view), rect, pjo);                             
				pj.send();
				
				if (sO.hasViewport) view.scrollRect = initScrRect;
		    }
			else
			{
		    	pjo = new PrintJobOptions();
				pjo.printAsBitmap = true;
				
				LayoutUtil.scaleTo(background_mc, view, sO, "CENTER", pj.pageHeight-80, pj.pageWidth-80);
				curScale = view.width/sO.owidth;

				view.rotation = 90;
				
				view.x = initX;
		    	view.y = initY;
				  		    	
		    	vp_curWidth = view.width * sO.vp_ohscale;
				vp_curHeight = view.height * sO.vp_owscale;
				
				yOffset = (pj.pageWidth-vp_curWidth)/2/curScale;
				xOffset = (pj.pageHeight-vp_curHeight)/2/curScale;
				
				trace("Portrait");
				trace("xOffset "+xOffset+" yOffset "+yOffset);
				
				rect = new Rectangle(-xOffset, 0, sO.vp_owidth+xOffset, sO.vp_oheight+yOffset);

				initScrRect = new Rectangle(0,0,view.width, view.height);				
				if (sO.hasViewport) view.scrollRect = new Rectangle(sO.vp_ox_offset, sO.vp_oy_offset, sO.vp_owidth, sO.vp_oheight);
								
		        pj.addPage(Sprite(view), rect, pjo);
		        pj.send();
		        
		        if (sO.hasViewport) view.scrollRect = initScrRect;
		        view.rotation = 0;
		    }
		   
		    view.width = initW * sO.vp_owscale;
			view.height = initH * sO.vp_ohscale;
			view.x = initX;
		    view.y = initY;	
		}
		
		public static function center2( back_mc : Object, _mc : DisplayObject, mcSnapShot : IDisplayObjectSnapShot = null) : void {
			//Center
			trace("HIGHLIGHT center2");
			// See if they are referrign to Stage or a component or not.
			if(mcSnapShot == null) {
				mcSnapShot = snapshotDimensions(_mc);
			}
			var w : Number = back_mc.width;
			var h : Number = back_mc.height;
			trace("w " + w + " h " + h);
			if (!mcSnapShot.hasViewport) {
				//works with non scaled clips
				trace("NO VIEWPORT ");
				_mc.x = getAlignH(back_mc, _mc);
				//((w-_mc.width)/2);// back_mc.x+((w-_mc.width)/2);
				_mc.y = getAlignV(back_mc, _mc);//((h-_mc.height)/2);//back_mc.y+((h-_mc.height)/2);
			} else {
				trace("HAS VIEWPORT ");
				//TODO: tring to figure out scaled clip center.
				// the scale factor between whe content (not the viewport)
				// was first loaded and where it is now.
				// want >1 if it's been scaled up.
				trace("mc.width " + _mc.width + " ow " + mcSnapShot.owidth);
				var sxf : Number = _mc.width / mcSnapShot.owidth;
				var syf : Number = 1;
				//_mc.height / mcSnapShot.height;
				trace("sxf " + sxf + " syf " + syf);
				var x_offset : Number = (sxf * mcSnapShot.vp_ox_offset);
				var y_offset : Number = (syf * mcSnapShot.vp_oy_offset);
				trace("xoffset " + x_offset + " y offset " + y_offset);
				trace("_mc.vp_owidth " + mcSnapShot.vp_owidth + " " + mcSnapShot.vp_oheight);
				var ww : Number = mcSnapShot.vp_owidth * sxf;
				var yy : Number = mcSnapShot.vp_oheight * syf;
				trace("ww " + ww + " yy " + yy);
				_mc.x = back_mc.x - x_offset;
				// + ((w - ww) / 2) - x_offset;
				_mc.y = back_mc.y;
				// - y_offset;// + ((h - yy) / 2) - y_offset;
				trace("resX " + _mc.x + " resY " + _mc.y);
			}
			//}
		}

		public static function scaleToStage(clip : DisplayObject,mcSnapShot : IDisplayObjectSnapShot, override_width : Number, override_height : Number) : void {
			trace("stage.stageWidth " + clip.stage.stageWidth + " mc " + clip.width);
			trace("stage.stageHeight " + clip.stage.stageHeight + " mc " + clip.height);
			//Scale
			var	sw : Number = (isNaN(override_width)) ? clip.stage.stageWidth : override_width;
			var sh : Number = (isNaN(override_height)) ? clip.stage.stageHeight : override_height;

			//	if (clip.isFullScreenMode)
			{
			//o_wh_asp and o_hw_asp are the original captured aspect ratio,
			//this is as captured from the IDE, and NOT the actionscript,
			//in order to get accurate onscreen representation.
			//scale to smallest dimension based on the relative aspect ratio
			var asRatios : Number = (sw / sh) / mcSnapShot.o_wh_asp;
			trace("aspect ratio " + asRatios + "  " + mcSnapShot.o_wh_asp);
			if (asRatios < 1 ) {
				trace("resizing width first");
				clip.width = sw;
				clip.height = sw / mcSnapShot.o_wh_asp;
					//clip.center ();
			} else if (asRatios > 1) {
				trace("resizing height first");
				clip.width = sh / mcSnapShot.o_hw_asp;
				clip.height = sh;
					//clip.center ();
			} else {
				trace("NOT resizing");
			}
				//clip.playerNav_mc.x = ((sw - (clip.playerNav_mc.width + clip.playerNav_mc.logo_mc.width )) / 2) + clip.playerNav_mc.logo_mc.width + 30 ;
				//			clip.playerNav_mc.y = (sh - clip.playerNav_mc.height) / 2;
				
		//	} else
		//	{
		//		clip.resetSizeAndPosition ();
			}
		}
	}
}
